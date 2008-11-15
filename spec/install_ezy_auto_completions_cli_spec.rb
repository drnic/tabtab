require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'install_ezy_auto_completions/cli'

describe InstallEzyAutoCompletions::CLI, "execute" do
  before(:each) do
    ENV['HOME'] = '/tmp/some/home'
    @cli = InstallEzyAutoCompletions::CLI.new
    @cli.expects(:config).returns({"external" => {"-h" => %w[test_app]}}).at_least(2)
    File.expects(:open).with('/tmp/some/home/.ezy_auto_completions.sh', 'w').returns(mock do
      expects(:<<).with("complete -o default -C 'ezy_auto_completions --external' test_app")
      expects(:close)
    end)
    @stdout_io = StringIO.new
    @cli.execute(@stdout_io, [])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should create a home file .ezy_auto_completions.sh" do
    # verify mocks
  end
end