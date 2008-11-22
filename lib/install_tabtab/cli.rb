require 'optparse'
require 'yaml'
require 'rubygems'

# TODO extract into BashCompletion.install ...
# TODO support non-Bash shells
module InstallTabTab
  class CLI
    include TabTab::LocalConfig
    
    attr_reader :options
    attr_reader :development_cli
    
    def self.execute(stdout, arguments=[])
      self.new.execute(stdout, arguments)
    end
    
    def execute(stdout, arguments=[])
      parse_options(arguments)
      @to_file = []
      install_externals
      install_for_files
      install_from_gems
      @file = File.open(File.join(home, ".tabtab.bash"), "w")
      @to_file.each { |line| @file << "#{line}\n" }
      @file.close
    end
   
    def parse_options(arguments)
      @options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: #{$0} [options]"
    
        opts.on("-d", "--development", "Generate .tabtab.bash to use local bin/tabtab instead of RubyGems tabtab") do |v|
          options[:development_cli] = v
        end
      end.parse!(arguments)
    end
   
    def install_externals
      return unless externals = config['external'] || config['externals']
      for app_name_or_hash in externals
        if app_name_or_hash.is_a?(String) || app_name_or_hash.is_a?(Symbol)
          install_cmd_and_aliases(app_name_or_hash.to_s, "--external")
        elsif app_name_or_hash.is_a?(Hash)
          app_name_or_hash.each do |flag, app_list|
            app_list.each do |app_name|
              install_cmd_and_aliases(app_name, "--external")
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
      install_cmd_and_aliases(app_name, "--file #{File.expand_path(file)}")
    end
    
    def install_from_gems
      find_gems_with_definition_files.each do |gem|
        gem[:app_names].each do |app_name|
          install_cmd_and_aliases(app_name, "--gem #{gem[:gem_name]}")
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

    def install_cmd_and_aliases(app_name, arg_str)
      tabtab = tabtab_cmd(arg_str)
      @to_file << "complete -o default -C '#{tabtab}' #{app_name}"
      aliases.each do |alias_cmd, cmd|
        if cmd == app_name
          tabtab = tabtab_cmd(arg_str, cmd)
          @to_file << "complete -o default -C '#{tabtab}' #{alias_cmd}"
        end
      end if aliases
    end
    
    def usage
      puts <<-EOS.gsub(/^      /, '')
      USAGE: create a file ~/.tabtab.yml
      EOS
      exit 1
    end
   
    def tabtab_cmd(flags, aliased_to=nil)
      tabtab = options[:development_cli] ? File.expand_path(File.dirname(__FILE__) + "/../../bin/tabtab") : "tabtab"
      aliased_to ? 
      "#{tabtab} #{flags} --alias #{aliased_to}" :
      "#{tabtab} #{flags}"
    end
    
    def aliases
      config["alias"] || config["aliases"]
    end
    
  end
end