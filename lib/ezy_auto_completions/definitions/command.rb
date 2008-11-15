module EzyAutoCompletions::Definition
  class Command < Base
    attr_reader :name, :description
    def initialize(name, description, &block)
      @name        = name
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
  end
end
