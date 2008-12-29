module TabTab::Definition
  class Default < Base
    attr_reader :description
    def initialize(parent, description=nil, &definition_block)
      @description = description
      super parent, &definition_block
    end
    
    def definition_type
      :default
    end

    def own_completions
      yield_result_block
    end
    
    def yield_result_block
      if definition_block.arity == -1 || definition_block.arity == 0
        definition_block.call
      elsif definition_block.arity == 1
        definition_block.call(self)
      else
        raise TabTab::Definition::InvalidDefinitionBlockArguments
      end
    end

    # Determines if current token matches this command's name
    def matches_token?(cmd_line_token)
      results = yield_result_block
      case results
      when String
        results == cmd_line_token.to_s
      when Array
        results.include?(cmd_line_token.to_s)
      else
        false
      end
    end

  end
end
