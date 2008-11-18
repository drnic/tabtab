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
      @file = File.open(File.join(home, ".tabtab.sh"), "w")
      @to_file.each { |line| @file << "#{line}\n" }
      @file.close
    end
   
    def install_externals
      return unless externals = config['external'] || config['externals']
      for help_arg in externals.keys
        app_list = externals[help_arg]
        app_list.each do |app_name|
          @to_file << "complete -o default -C 'tabtab --external' #{app_name}"
        end unless app_list.nil?
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
      @to_file << "complete -o default -C 'tabtab --file #{File.expand_path(file)}' #{app_name}"
    end
    
    def install_from_gems
      find_gems_with_definition_files.each do |gem|
        gem[:app_names].each do |app_name|
          @to_file << "complete -o default -C 'tabtab --gem #{gem[:gem_name]}' #{app_name}"
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
    
  end
end