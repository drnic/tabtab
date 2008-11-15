module EzyAutoCompletions::Definition
  class Root < Base
    attr_reader :app_name

    def self.named(app_name, &block)
      self.new(app_name, &block)
    end

    def initialize(app_name, &block)
      @app_name = app_name
      super(nil, &block)
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
