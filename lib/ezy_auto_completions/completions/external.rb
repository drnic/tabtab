class EzyAutoCompletions::Completions::External
  def initialize(options_str)
    @options_str = options_str
  end
  
  # Returns list of long and short options for an application's --help display
  # which was passed into initializer
  def extract
    @extract ||= begin
      lines_containing_options = @options_str.split(/\n/).grep(/^[\s\t]+-/)
      all_options = lines_containing_options.inject([]) do |list, line|
        list + line.scan(/(?:^\s+|,\s)(-[\w-]+)/).flatten
      end
      long_options = all_options.grep(/^--/).sort
      short_options = (all_options - long_options).sort
      long_options + short_options
    end
  end
  
  # Returns the sub-list of all options filtered by a common prefix
  # e.g. if current +extract+ list is +['--help', '--extra', '-h', '-x']+
  # then +starts_with('--')+ returns +['--help', '--extra']+
  def starts_with(prefix)
    extract.grep(/^#{prefix}/)
  end
end
