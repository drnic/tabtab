require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'install_tabtab/cli'

describe InstallTabTab::CLI, "with --external app flag" do
  before(:each) do
    ENV['HOME'] = '/tmp/some/home'
    @cli = InstallTabTab::CLI.new
    @cli.expects(:config).returns({"external" => {"-h" => %w[test_app]}}).at_least(2)
    File.expects(:open).with('/tmp/some/home/.tabtab.sh', 'w').returns(mock do
      expects(:<<).with("complete -o default -C 'tabtab --external' test_app")
      expects(:close)
    end)
    @stdout_io = StringIO.new
    @cli.execute(@stdout_io, ['--external', 'some_app', '', 'some_app'])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should create a home file .tabtab.sh" do
    # verify mocks
  end
end