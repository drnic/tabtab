require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "ezy_auto_completions/framework_testing"

describe EzyAutoCompletions::FrameworkTesting, "can be auto-completed with simple flag" do
  before(:each) do
    @definitions = EzyAutoCompletions::Definition::Root.named('myapp') do |c|
      c.flags :flag, :f
    end
  end
  
  it "should allow 'myapp --flag'" do
    'myapp --flag'.should be_autocompletable_from(@definitions)
  end
end

describe EzyAutoCompletions::FrameworkTesting, "can be auto-completed with simple command" do
  before(:each) do
    @definitions = EzyAutoCompletions::Definition::Root.named('myapp') do |c|
      c.command :run
      c.command :stop
    end
  end
  
  %w[run stop].each do |cmd|
    it "should allow 'myapp #{cmd}'" do
      "myapp #{cmd}".should be_autocompletable_from(@definitions)
    end
  end
end

describe EzyAutoCompletions::FrameworkTesting, "can be auto-completed with command and an argument" do
  before(:each) do
    @definitions = EzyAutoCompletions::Definition::Root.named('myapp') do |c|
      c.command :run do
        %w[aaaa bbbb cccc]
      end
      c.command :stop do |stop|
        stop.default do
          %w[aaaa bbbb cccc]
        end
      end
    end
  end
  
  it "should allow 'myapp run'" do
    'myapp run'.should be_autocompletable_from(@definitions)
  end

  %w[run stop].each do |cmd|
    it "should allow 'myapp #{cmd} bbbb'" do
      "myapp #{cmd} bbbb".should be_autocompletable_from(@definitions)
    end
  end
  
end
