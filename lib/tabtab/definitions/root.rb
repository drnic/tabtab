module TabTab::Definition
  class Root < Base
    attr_reader :app_name, :current_token

    def self.named(app_name, options = {}, &block)
      self.new(app_name, options, &block)
    end

    def initialize(app_name, options = {}, &block)
      @app_name = app_name
      super(nil, &block)
      import_help_flags(options[:import]) if options[:import]
    end
    
    def extract_completions(previous_token, current_token)
      @current_token = current_token
      current = find_active_definition_for_last_token(previous_token) || self
      current = (current.parent || self) if current.tokens_consumed == 1
      completions = current.filtered_completions(current_token)
      grouped = {:long => [], :short => [], :command => []}
      grouped = completions.inject(grouped) do |mem, token|
        if token =~ /^--/
          mem[:long] << token
        elsif token =~ /^-/
          mem[:short] << token
        else
          mem[:command] << token
        end
        mem
      end
      grouped[:command].sort + grouped[:long].sort + grouped[:short].sort
    end

    def definition_type
      :root
    end
    
    # Example usage:
    #   c.default do
    #     %w[possible values following command name]
    #   end
    # which map to example command-line expressions:
    #   myapp this_command possible
    #   myapp this_command value
    #   myapp this_command following
    def default(description=nil, &block)
      contents << TabTab::Definition::Default.new(self, description, &block)
    end

    # Determines if current token matches the app name
    def matches_token?(cmd_line_token)
      cmd_line_token == app_name
    end
    
    def import_help_flags(help_flag)
      help_flag = "--help" unless help_flag.is_a?(String)
      imported_flags = TabTab::Completions::External.new(app_name, help_flag).extract
      imported_flags.each do |flag|
        flag.gsub!(/^-*/, '')
        next unless flag.size > 0
        self.flag(flag.to_sym)
      end
    end
  end
end
