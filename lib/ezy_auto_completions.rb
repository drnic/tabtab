$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module EzyAutoCompletions
  VERSION = '0.0.1'
  
  class ExtractHelpOptions
    def initialize(options_str)
      @options_str = options_str
    end
    
    # Returns list of long and short options for an application's --help display
    # which was passed into initializer
    def extract
      lines_containing_options = @options_str.split(/\n/).grep(/^[\s\t]+-/)
      all_options = lines_containing_options.inject([]) do |list, line|
        list + line.scan(/(?:^\s+|,\s)(-[\w-]+)/).flatten
      end
      long_options = all_options.grep(/^--/).sort
      short_options = (all_options - long_options).sort
      long_options + short_options
    end
  end
end