$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module EzyAutoCompletions
  VERSION = '0.0.1'
end

require 'ezy_auto_completions/local_config'
require 'ezy_auto_completions/completions'
require 'ezy_auto_completions/definitions'