module EzyAutoCompletions::Definition
  class Command < Base
    attr_reader :name, :description
    def initialize(definition, name, description, &block)
      super description
      @name        = name.to_s
      @description = description
    end

    # Example usage:
    #   c.default do
    #     %w[possible values following command name]
    #   end
    # which map to example command-line expressions:
    #   myapp this_command possible
    #   myapp this_command value
    #   myapp this_command following
    def default(&block)

    end

    # Determines if current token matches this command's name
    def matches_token?(cmd_line_token)
      cmd_line_token == name
    end
  end
end
