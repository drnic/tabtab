require 'yaml'

module InstallEzyAutoCompletions
  class CLI
    def self.execute(stdout, arguments=[])
      self.new.execute(stdout, arguments)
    end
    
    def execute(stdout, arguments=[])
      config_file = File.join(home, '.ezy_auto_completions.yml')
      usage unless File.exists?(config_file)
      @config = YAML.load(File.read(config_file))
      install_externals
    end
   
    def install_externals
      externals = @config['external'] || @config['externals']
      for help_arg in externals.keys
        app_list = externals[help_arg]
        # TODO extract into BashCompletion.install ...
        # TODO support non-Bash shells
        app_list.each do |app|
          system "complete -o default -C ezy_auto_completions #{app}"
        end unless app_list.nil? || app_list.empty?
      end
    end
    
    def home
      ENV["HOME"] || ENV["HOMEPATH"] || File::expand_path("~")
    end
    
    def usage
      puts <<-EOS.gsub(/^      /, '')
      USAGE: create a file ~/.ezy_auto_completions.yml
      EOS
      exit 1
    end
  end
end