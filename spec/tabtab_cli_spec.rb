require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'tabtab/cli'

describe TabTab::CLI, "--external flag to generate completion definitions from -h help description" do
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

describe TabTab::CLI, "--gem flag to local completion definitions in file" do
  before(:each) do
    @cli = TabTab::CLI.new
    TabTab::Completions::Gem.any_instance.expects(:load_gem_and_return_definitions_file).returns('/path/to/definition.rb')
    File.expects(:read).with('/path/to/definition.rb').returns(<<-EOS.gsub(/^      /,''))
      TabTab::Definition.register('test_app') do |c|
        c.flags :help, :h, "help"
        c.flags :extra, :x
      end
    EOS
    @cli.expects(:config).never
    @stdout_io = StringIO.new
    @cli.execute(@stdout_io, ['--gem', 'my_gem', 'test_app', '', 'test_app'])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should print completions" do
    @stdout.should == <<-EOS.gsub(/^    /, '')
    --extra
    --help
    -h
    -x
    EOS
  end
end

describe TabTab::CLI, "--file flag to local completion definitions in file" do
  before(:each) do
    @cli = TabTab::CLI.new
    File.expects(:read).with('/path/to/definition.rb').returns(<<-EOS.gsub(/^      /,''))
      TabTab::Definition.register('test_app') do |c|
        c.flags :help, :h, "help"
        c.flags :extra, :x
      end
    EOS
    File.expects(:exists?).with('/path/to/definition.rb').returns(true).at_least(1)
    @cli.expects(:config).never
    @stdout_io = StringIO.new
    @cli.execute(@stdout_io, ['--file', '/path/to/definition.rb', 'test_app', '', 'test_app'])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should print completions" do
    @stdout.should == <<-EOS.gsub(/^    /, '')
    --extra
    --help
    -h
    -x
    EOS
  end
end