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

require File.dirname(__FILE__) + "/../../lib/tabtab"
require File.dirname(__FILE__) + "/../../lib/install_tabtab/cli"


