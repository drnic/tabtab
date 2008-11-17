module TabTab::Definition
  class Flag < Base
    attr_reader :definition, :flags, :description
    def initialize(definition, flags, description, &block)
      @flags       = flags.map { |flag| flag.to_s }
      @description = description
      super definition, &block
    end
    
    def definition_type
      :flag
    end

    # How many tokens/parts of a command-line expression does this Flag consume
    # For example, the following consume 1 token:
    #   --simple
    #   -s
    # The following consumes 2 tokens:
    #   --port 1234
    def tokens_consumed
      definition_block.nil? ? 1 : 2
    end

    # convert flags into --flag or -f based on length of value
    def own_completions
      flags.map do |flag|
        flag.size > 1 ? "--#{flag}" : "-#{flag}"
      end
    end
    
    # Determines if current token matches this command's flags
    def matches_token?(cmd_line_token)
      return false unless cmd_line_token
      flags.include? cmd_line_token.gsub(/^-*/,'')
    end
    
  end
end
