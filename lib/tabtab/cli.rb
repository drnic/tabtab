require 'optparse'

module TabTab
  class CLI
    include TabTab::LocalConfig

    attr_reader :stdout
    attr_reader :app_type, :full_line

    def self.execute(stdout, arguments=[])
      self.new.execute(stdout, arguments)
    end
    
    def execute(stdout, arguments=[])
      @stdout = stdout
      @full_line = ENV['COMP_LINE']
      usage unless @app_type = arguments.shift
      case @app_type.gsub(/^-*/, '').to_sym
      when :external
        process_external *arguments
      when :gem
        process_gem arguments
      end
    end
    
    #
    # Support for external apps (optionally configured in ~/.tabtab.yml)
    #
    def process_external(app_name, current, previous)
      usage unless config
      options_flag = externals.find { |flag, app_list| app_list.include?(app_name) }
      options_flag = options_flag.nil? ? '-h' : options_flag.first
      stdout.puts external_options(app_name, options_flag).starts_with(current)
    end
    
    def externals
      config["external"] || config["externals"]
    end
    
    def external_options(app, options_flag)
      TabTab::Completions::External.new(app, options_flag)
    end
    
    #
    # Support for RubyGem-based apps (found in any gem path)
    #
    def process_gem arguments
      stdout.puts TabTab::Completions::Gem.new(*arguments).extract.join("\n")
    end
  end
end