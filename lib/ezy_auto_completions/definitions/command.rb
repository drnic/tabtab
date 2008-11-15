module EzyAutoCompletions::Definition
  class Command < Base
    attr_reader :name, :description
    def initialize(definition, name, description, &block)
      @name        = name.to_s
      @description = description
      super description, &block
    end
    
    def definition_type
      :command
    end
    
    # How many tokens/parts of a command-line expression does this Flag consume
    # For example, the following consume 1 token:
    #   --simple
    #   -s
    # The following consumes 2 tokens:
    #   --port 1234
    def tokens_consumed
      return 2 if definition_block
      1
    end

    def own_completions
      [name]
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
      contents << EzyAutoCompletions::Definition::Default.new(description, &block)
    end

    # Determines if current token matches this command's name
    def matches_token?(cmd_line_token)
      cmd_line_token == name
    end

  end
end
