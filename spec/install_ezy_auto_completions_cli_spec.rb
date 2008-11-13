require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'install_ezy_auto_completions/cli'

describe InstallEzyAutoCompletions::CLI, "execute" do
  before(:each) do
    @cli = InstallEzyAutoCompletions::CLI.new
    @cli.expects(:config).returns({"external" => {"-h" => %w[test_app]}}).at_least(2)
    @stdout_io = StringIO.new
    @cli.execute(@stdout_io, [])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should do run the local 'complete' in-built command"
end