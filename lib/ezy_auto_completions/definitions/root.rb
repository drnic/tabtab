module EzyAutoCompletions::Definition
  class Root < Base
    attr_reader :app_name

    def self.named(app_name, &block)
      definition = self.new(app_name)
      yield definition
      definition
    end

    def initialize(app_name)
      super
      @app_name = app_name
    end

    def autocompletable?(cmd_line)
      false
    end
  end
end
