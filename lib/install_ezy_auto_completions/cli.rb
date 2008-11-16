require 'yaml'
require 'ezy_auto_completions/local_config'

# TODO extract into BashCompletion.install ...
# TODO support non-Bash shells
module InstallEzyAutoCompletions
  class CLI
    include EzyAutoCompletions::LocalConfig
    
    def self.execute(stdout, arguments=[])
      self.new.execute(stdout, arguments)
    end
    
    def execute(stdout, arguments=[])
      usage unless config
      @to_file = File.open(File.join(home, ".ezy_auto_completions.sh"), "w")
      install_externals
      install_from_gems
      @to_file.close
    end
   
    def install_externals
      externals = config['external'] || config['externals']
      for help_arg in externals.keys
        app_list = externals[help_arg]
        app_list.each do |app|
          @to_file << "complete -o default -C 'ezy_auto_completions --external' #{app}"
        end unless app_list.nil?
      end
    end
    
    def install_from_gems
      require "pp"
      pp Gem.all_load_paths.select do |path|
        Dir[File.join(path, "**", "ezy_auto_completions_definitions.rb")].first
      end
    end
    
    def usage
      puts <<-EOS.gsub(/^      /, '')
      USAGE: create a file ~/.ezy_auto_completions.yml
      EOS
      exit 1
    end
    
  end
end