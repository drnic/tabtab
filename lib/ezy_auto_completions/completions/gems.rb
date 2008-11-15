class EzyAutoCompletions::Completions::Gem
  attr_reader :app_name
  
  def initialize(app_name, current = '', previous = app_name)
    @app_name = app_name
    @current  = current
    @previous = previous
  end

  # Returns the sub-list of all options filtered by a common prefix
  # e.g. if current +extract+ list is +['--help', '--extra', '-h', '-x']+
  # then +starts_with('--')+ returns +['--help', '--extra']+
  def extract
    ""
  end
end
