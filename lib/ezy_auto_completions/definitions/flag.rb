module EzyAutoCompletions::Definition
  class Flag < Base
    attr_reader :definition, :flags, :description
    def initialize(definition, flags, description, &block)
      @definition  = definition
      @flags       = flags
      @description = description
    end
  end
end
