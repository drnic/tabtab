module TabTab::Definition
  class Default < Base
    attr_reader :description
    def initialize(definition, description=nil, &block)
      @description = description
      super definition, &block
    end
    
    def definition_type
      :default
    end

    def own_completions
      yield_result_block
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
