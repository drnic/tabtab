require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ezy_auto_completions/cli'

describe EzyAutoCompletions::CLI, "execute for all options" do
  before(:each) do
    @cli = EzyAutoCompletions::CLI.new
    @options = mock do
      expects(:starts_with).with(nil).returns(['--help', '--extra', '-h', '-x'])
    end
    @cli.expects(:external_options).with('test_app', '-h').returns(@options)
    @cli.expects(:config).returns({"external" => {"-h" => %w[test_app]}}).at_least(2)
    @stdout_io = StringIO.new
    @cli.execute(@stdout_io, %w[test_app])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should fucking do something here... brain... doing some thinking please"
end