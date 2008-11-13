require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'install_ezy_auto_completions/cli'

describe InstallEzyAutoCompletions::CLI, "execute" do
  before(:each) do
    @stdout_io = StringIO.new
    InstallEzyAutoCompletions::CLI.execute(@stdout_io, [])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should do something" do
    @stdout.should_not =~ /To update this executable/
  end
end