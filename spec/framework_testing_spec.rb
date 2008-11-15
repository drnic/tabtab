require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "ezy_auto_completions/framework_testing"

describe EzyAutoCompletions::FrameworkTesting, "can be auto-completed" do
  before(:each) do
    @definitions = EzyAutoCompletions::Definition::Root.named('myapp') do |c|
      c.flags :flag, :f
    end
  end
  
  it "should allow 'myapp --flag'" do
    'myapp --flag'.should be_autocompletable_from(@definitions)
  end
end