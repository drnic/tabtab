class EzyAutoCompletions::Definition::Base
  attr_reader :parent, :contents, :definition_block
  
  def initialize(parent, &block)
    @parent           = parent
    @contents         = []
    @definition_block = block
    yield_definition_block
  end
  
  # Example usage:
  #   c.flags :some_flag
  #   c.flags :some_flag, :s, "a description"
  #   c.flags :another_flag, "a description" do
  #       %w[possible values for the flag]
  #   end
  # which map to example command-line expressions:
  #   myapp --some_flag
  #   myapp -s
  #   myapp --another_flag possible
  #   myapp --another_flag values
  def flags(*flags_and_description, &block)
    description = flags_and_description.pop if flags_and_description.last.is_a?(String)
    flag_names  = flags_and_description
    contents << EzyAutoCompletions::Definition::Flag.new(self, flag_names, description, &block)
  end
  alias_method :flag, :flags

  # Example usage:
  #   c.command :run
  #   c.command :run, "Runs the good stuff"
  #   c.command :choose, "Runs the good stuff", do
  #      %w[possible values for the commands argument]
  #   end
  #   c.command :set_speed, "Runs the good stuff", do |run|
  #      run.flags :a_flag
  #      run.command :slowly
  #      run.command :fast
  #   end
  # which map to example command-line expressions:
  #   myapp run
  #   myapp choose possible
  #   myapp set_speed --a_flag fast
  def command(name, description="", &block)
    contents << EzyAutoCompletions::Definition::Command.new(self, name, description, &block)
  end

  # Helper for test frameworks
  def autocompletable?(cmd_line_or_tokens)
    tokens = cmd_line_or_tokens.is_a?(String) ? cmd_line_or_tokens.split(/\s/) : cmd_line_or_tokens
    current, *remainder = tokens
    return false unless matches_token?(current) # current cmd-line doesn't match this Definition
    return true if remainder.empty?
    if definition = find_definition_by_token(current, remainder)
      return definition.autocompletable?(remainder)
    end
    yield_result_block
  end
  
  def yield_definition_block
    if definition_block.nil?
      return
    elsif definition_block.arity == -1
      # these blocks return a result/do lots of work - don't run them now
    elsif definition_block.arity == 1
      definition_block.call self
    else
      raise EzyAutoCompletions::Definition::InvalidDefinitionBlockArguments
    end
  end

  def yield_result_block
    if definition_block.nil? || definition_block.arity == 1
      nil
    elsif definition_block.arity == -1
      definition_block.call
    else
      raise EzyAutoCompletions::Definition::InvalidDefinitionBlockArguments
    end
  end


  protected
  
  # To be implemented by subclasses.
  # Determines if this definition matches the current token
  def matches_token?(cmd_line_token)
    false
  end

  def find_definition_by_token(cmd_line_token, remainder)
    contents.find do |definition|
      definition.autocompletable?(remainder)
    end
  end
end
