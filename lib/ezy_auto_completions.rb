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
      []
    end
  end
end