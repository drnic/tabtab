class EzyAutoCompletions::Definition::Base
  attr_reader :parent, :contents
  
  def initialize(parent)
    @parent   = parent
    @contents = []
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
  #   c.command "run"
  #   c.command "run", "Runs the good stuff"
  #   c.command "choose", "Runs the good stuff", do
  #      %w[possible values for the commands argument]
  #   end
  #   c.command "set_speed", "Runs the good stuff", do |run|
  #      run.flags :a_flag
  #      run.command "slowly"
  #      run.command "fast"
  #   end
  # which map to example command-line expressions:
  #   myapp run
  #   myapp choose possible
  #   myapp set_speed --a_flag fast
  def command(name, description="", &block)
    
  end
  
end
