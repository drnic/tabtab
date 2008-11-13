require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ezy_auto_completions/cli'

describe EzyAutoCompletion::CLI, "execute" do
  before(:each) do
    @stdout_io = StringIO.new
    EzyAutoCompletion::CLI.execute(@stdout_io, [])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should run target app with -h to determine options"
  
  it "should extract options and print them on separate lines"
end