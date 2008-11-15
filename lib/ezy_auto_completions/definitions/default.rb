module EzyAutoCompletions::Definition
  class Default < Base
    def initialize(description=nil, &block)
      super description, &block
    end
    
    def definition_type
      :default
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
