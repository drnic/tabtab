require 'optparse'

module EzyAutoCompletions
  class CLI
    include EzyAutoCompletions::LocalConfig

    attr_reader :stdout
    attr_reader :app_type, :app_name, :previous, :current

    def self.execute(stdout, arguments=[])
      self.new.execute(stdout, arguments)
    end
    
    def execute(stdout, arguments=[])
      @stdout = stdout
      usage unless @app_type = arguments.shift
      @app_name, @current, @previous = arguments
      case @app_type.gsub!(/^-*/, '').to_sym
      when :external
        process_external
      when :gem
        process_gem
      end
    end
    
    #
    # Support for external apps (optionally configured in ~/.ezy_auto_completions.yml)
    #
    def process_external
      usage unless config
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
    
    #
    # Support for RubyGem-based apps (found in any gem path)
    #
    def process_gem
      stdout.puts rubygems_completions.starts_with(current)
    end
    
    def rubygems_completions
      EzyAutoCompletions::RubyGemCompletions.new(app_name)
    end
  end
end