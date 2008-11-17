module TabTab::Definition
  class Root < Base
    attr_reader :app_name, :current_token

    def self.named(app_name, &block)
      self.new(app_name, &block)
    end

    def initialize(app_name, &block)
      @app_name = app_name
      super(nil, &block)
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
  end
end
