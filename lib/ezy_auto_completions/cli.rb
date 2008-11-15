require 'optparse'

module EzyAutoCompletions
  class CLI
    include EzyAutoCompletions::LocalConfig

    def self.execute(stdout, arguments=[])
      self.new.execute(stdout, arguments)
    end
    
    def execute(stdout, arguments=[])
      usage unless config # TODO not fatal - try --auto-completion-script option?
      app, *args = arguments
      options_flag = externals.find { |flag, app_list| app_list.include?(app) }
      options_flag = options_flag.nil? ? '-h' : options_flag.first
      stdout.puts external_options(app, options_flag).starts_with(args.first)
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