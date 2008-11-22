$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module TabTab
  VERSION = '0.9.0'
end

require 'tabtab/local_config'
require 'tabtab/completions'
require 'tabtab/definitions'