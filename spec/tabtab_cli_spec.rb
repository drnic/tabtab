require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'tabtab/cli'

describe TabTab::CLI, "execute and find completions for external" do
  before(:each) do
    @cli = TabTab::CLI.new
    @options = mock do
      expects(:starts_with).with('').returns(['--help', '--extra', '-h', '-x'])
    end
    @cli.expects(:external_options).with('test_app', '-h').returns(@options)
    @cli.expects(:config).returns({"external" => {"-h" => %w[test_app]}}).at_least(2)
    @stdout_io = StringIO.new
    @cli.execute(@stdout_io, ['--external', 'test_app', '', 'test_app'])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should print completions" do
    @stdout.should == <<-EOS.gsub(/^    /, '')
    --help
    --extra
    -h
    -x
    EOS
  end
end

describe TabTab::CLI, "execute and find completions for gem-based apps" do
  before(:each) do
    @cli = TabTab::CLI.new
    @options = mock do
      expects(:starts_with).with('').returns(['--help', '--extra', '-h', '-x'])
    end
    @cli.expects(:config).never
    @stdout_io = StringIO.new
    @cli.execute(@stdout_io, ['--gem', 'test_app', '', 'test_app'])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should print completions" do
    @stdout.should == <<-EOS.gsub(/^    /, '')
    --help
    --extra
    -h
    -x
    EOS
  end
end