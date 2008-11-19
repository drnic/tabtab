require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'tabtab/cli'

def it_should_print_completions
  it "should print completions" do
    @stdout_io.rewind
    @stdout = @stdout_io.read
    @stdout.should == <<-EOS.gsub(/^    /, '')
    --extra
    --help
    -h
    -x
    EOS
  end
end

describe TabTab::CLI, "--external flag" do
  before(:each) do
    @cli = TabTab::CLI.new
    TabTab::Completions::External.any_instance.expects(:options_str).returns(<<-EOS.gsub(/^    /, ''))
      --help, -h   
      --extra, -x   
    EOS
    @stdout_io = StringIO.new
  end
  
  describe "to generate completion definitions from -h help description" do
    before(:each) do
      @cli.expects(:config).returns({"external" => %w[test_app]}).at_least(2)
      @cli.execute(@stdout_io, ['--external', 'test_app', '', 'test_app'])
    end
    it_should_print_completions
  end
  
  describe "with --alias ALIAS" do
    before(:each) do
      @cli.expects(:config).returns({"external" => %w[test_app]}).at_least(2)
      @cli.execute(@stdout_io, ['--external', '--alias', 'test_app', 'test', '', 'test'])
    end
    it_should_print_completions
  end
end

describe TabTab::CLI, "--external flag" do
  describe "with app_name and explicit -X flag" do
    before(:each) do
      @cli = TabTab::CLI.new
      @stdout_io = StringIO.new
      TabTab::Completions::External.expects(:new).with("test_app", '-?', {:shortflags=>"enable"}).returns(mock do
        expects(:starts_with).with("").returns(%w[--extra --help -h -x])
      end)
      @cli.expects(:config).returns({"external" => [ {"-?" => %w[test_app] } ] }).at_least(2)
      @cli.execute(@stdout_io, ['--external', 'test_app', '', 'test_app'])
    end
    it_should_print_completions
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
    @cli.expects(:config).returns({}).at_least(1)
    @stdout_io = StringIO.new
  end

  describe "to local completion definitions in file" do
    before(:each) do
      @cli.execute(@stdout_io, ['--gem', 'my_gem', 'test_app', '', 'test_app'])
    end
    it_should_print_completions
  end
  
  describe "with --alias ALIAS" do
    before(:each) do
      @cli.execute(@stdout_io, ['--gem', 'my_gem', '--alias', 'test_app', 'test', '', 'test'])
    end
    it_should_print_completions
  end
  
end

describe TabTab::CLI, "--file flag" do
  before(:each) do
    @cli = TabTab::CLI.new
    File.expects(:read).with('/path/to/definition.rb').returns(<<-EOS.gsub(/^      /,''))
      TabTab::Definition.register('test_app') do |c|
        c.flags :help, :h, "help"
        c.flags :extra, :x
      end
    EOS
    File.expects(:exists?).with('/path/to/definition.rb').returns(true).at_least(1)
    @cli.expects(:config).returns({}).at_least(1)
    @stdout_io = StringIO.new
  end

  describe "to local completion definitions in file" do
    before(:each) do
      @cli.execute(@stdout_io, ['--file', '/path/to/definition.rb', 'test_app', '', 'test_app'])
    end
    it_should_print_completions
  end

  describe "with --alias ALIAS" do
    before(:each) do
      @cli.execute(@stdout_io, ['--file', '/path/to/definition.rb', '--alias', 'test_app', 'test', '', 'test'])
    end
    it_should_print_completions
  end
end

