require 'yaml'
require 'tabtab/local_config'

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
      @to_file = File.open(File.join(home, ".tabtab.sh"), "w")
      install_externals
      install_from_gems
      @to_file.close
    end
   
    def install_externals
      externals = config['external'] || config['externals']
      for help_arg in externals.keys
        app_list = externals[help_arg]
        app_list.each do |app|
          @to_file << "complete -o default -C 'tabtab --external' #{app}"
        end unless app_list.nil?
      end
    end
    
    def install_from_gems
      definition_files = find_all_definition_files_from_gems

    end
    
    def find_all_definition_files_from_gems
      Gem.all_load_paths.inject([]) do |mem, path|
        if file = Dir[File.join(path, "**", "tabtab_definitions.rb")].first
          mem << file if file
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