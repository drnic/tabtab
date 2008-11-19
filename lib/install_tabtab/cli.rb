require 'yaml'
require 'rubygems'

# TODO extract into BashCompletion.install ...
# TODO support non-Bash shells
module InstallTabTab
  class CLI
    include TabTab::LocalConfig
    
    def self.execute(stdout, arguments=[])
      self.new.execute(stdout, arguments)
    end
    
    def execute(stdout, arguments=[])
      usage unless config
      @to_file = []
      install_externals
      install_for_files
      install_from_gems
      @file = File.open(File.join(home, ".tabtab.bash"), "w")
      @to_file.each { |line| @file << "#{line}\n" }
      @file.close
    end
   
    def install_externals
      return unless externals = config['external'] || config['externals']
      for app_name_or_hash in externals
        if app_name_or_hash.is_a?(String) || app_name_or_hash.is_a?(Symbol)
          app_name = app_name_or_hash.to_s
          tabtab = tabtab_cmd('--external', app_name)
          @to_file << "complete -o default -C '#{tabtab}' #{app_name}"
        elsif app_name_or_hash.is_a?(Hash)
          app_name_or_hash.each do |flag, app_list|
            app_list.each do |app_name|
              tabtab = tabtab_cmd('--external', app_name)
              @to_file << "complete -o default -C '#{tabtab}' #{app_name}"
            end
          end
        end
      end
    end
    
    def install_for_files
      return unless files_and_names = config['file'] || config['files']
      for file in files_and_names.keys
        case app_names = files_and_names[file]
        when String
          install_file file, app_names
        when Array
          app_names.each { |app_name| install_file(file, app_name) }
        end
      end
    end
    
    def install_file(file, app_name)
      tabtab = tabtab_cmd("--file #{File.expand_path(file)}", app_name)
      @to_file << "complete -o default -C '#{tabtab}' #{app_name}"
    end
    
    def install_from_gems
      find_gems_with_definition_files.each do |gem|
        gem[:app_names].each do |app_name|
          tabtab = tabtab_cmd("--gem #{gem[:gem_name]}", app_name)
          @to_file << "complete -o default -C '#{tabtab}' #{app_name}"
        end
      end
    end
    
    def find_gems_with_definition_files
      Gem.all_load_paths.inject([]) do |mem, path|
        if file = Dir[File.join(path, "**", "tabtab_definitions.rb")].first
          gem_name = file.match(/\/([^\/]*)-\d+.\d+.\d+\/lib\//)[1]
          TabTab::Definition.clear
          eval File.read(file)
          mem << { :gem_name => gem_name, :app_names => TabTab::Definition.app_names }
        end
        mem
      end
    end
    
    def usage
      puts <<-EOS.gsub(/^      /, '')
      USAGE: create a file ~/.tabtab.yml
      EOS
      exit 1
    end
   
    def tabtab_cmd(flags, user_str)
      "tabtab #{flags}#{alias_for(user_str)}"
    end
    
    def alias_for(user_str)
      return "" unless aliases = config["alias"] || config["aliases"]
      aliases[user_str] ? " --alias #{aliases[user_str]}" : ""
    end
  end
end