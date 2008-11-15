require 'optparse'

module EzyAutoCompletions
  class CLI
    include EzyAutoCompletions::LocalConfig

    attr_reader :app_type, :app_name, :previous, :current

    def self.execute(stdout, arguments=[])
      self.new.execute(stdout, arguments)
    end
    
    def execute(stdout, arguments=[])
      usage unless @app_type = arguments.shift
      @app_name, @current, @previous = arguments
      usage unless config # TODO not fatal - try --auto-completion-script option?
      options_flag = externals.find { |flag, app_list| app_list.include?(app_name) }
      options_flag = options_flag.nil? ? '-h' : options_flag.first
      stdout.puts external_options(app_name, options_flag).starts_with(current)
    end
    
    def externals
      config["external"] || config["externals"]
    end
    
    def external_options(app, options_flag)
      options_str = `#{app} #{options_flag}`
      EzyAutoCompletions::ExtractHelpOptions.new(options_str)
    end
  end
end