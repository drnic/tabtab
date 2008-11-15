module EzyAutoCompletions::Definition
  class Root < Base
    attr_reader :app_name

    def self.named(app_name, &block)
      definition = self.new(app_name)
      yield definition
      definition
    end

    def initialize(app_name)
      super(nil)
      @app_name = app_name
    end

    # Determines if current token matches the app name
    def matches_token?(cmd_line_token)
      cmd_line_token == app_name
    end
  end
end
