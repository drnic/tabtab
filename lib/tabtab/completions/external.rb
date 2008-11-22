class TabTab::Completions::External
  attr_reader :global_config

  def initialize(app_name, options_flag = '-h', global_config = {})
    @app_name     = app_name
    @options_flag = options_flag
    @global_config  = global_config
  end
  
  def options_str
    @options_str ||= `#{@app_name} #{@options_flag}`
  end
  
  # Returns list of long and short options for an application's --help display
  # which was passed into initializer
  def extract(_options_str = nil)
    @options_str = _options_str if _options_str # hook for testing
    @extract ||= begin
      lines_containing_options = options_str.split(/\n/).grep(/^[\s\t]+-/)
      all_options = lines_containing_options.inject([]) do |list, line|
        list + line.scan(/(?:^\s+|,\s)(-[\w-]+)/).flatten
      end
      long_options  = all_options.grep(/^--/).sort
      short_options = hide_short_flags? ? [] : (all_options - long_options).sort
      long_options + short_options
    end
  end
  
  # Returns the sub-list of all options filtered by a common prefix
  # e.g. if current +extract+ list is +['--help', '--extra', '-h', '-x']+
  # then +starts_with('--')+ returns +['--help', '--extra']+
  def starts_with(prefix)
    extract.grep(/^#{prefix}/)
  end

  def hide_short_flags?
    global_config[:shortflags] == 'disable'
  end
end
