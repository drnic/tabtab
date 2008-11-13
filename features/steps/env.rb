require File.dirname(__FILE__) + "/../../lib/ezy_auto_completions"

gem 'cucumber'
require 'cucumber'
gem 'rspec'
require 'spec'
gem 'mocha'
require 'mocha'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

require 'yaml'