module TabTab::Definition
  class Root < Base
    attr_reader :app_name

    def self.named(app_name, &block)
      self.new(app_name, &block)
    end

    def initialize(app_name, &block)
      @app_name = app_name
      super(nil, &block)
    end
    
    def extract_completions(previous_token, current_token)
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
    
    # Determines if current token matches the app name
    def matches_token?(cmd_line_token)
      cmd_line_token == app_name
    end
  end
end
