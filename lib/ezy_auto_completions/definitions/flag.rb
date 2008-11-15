module EzyAutoCompletions::Definition
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

    # convert flags into --flag or -f based on length of value
    def own_completions
      flags.map do |flag|
        flag.size > 1 ? "--#{flag}" : "-#{flag}"
      end
    end
    
    # Determines if current token matches this command's flags
    def matches_token?(cmd_line_token)
      flags.include? cmd_line_token.gsub(/^-*/,'')
    end
    
  end
end
