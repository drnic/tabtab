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

describe TabTab::CLI, "--gem GEM_NAME loads from tabtab_definitions.rb in gem" do
  before(:each) do
    @cli = TabTab::CLI.new
    TabTab::Completions::Gem.any_instance.expects(:load_gem_and_return_definitions_file).returns('/path/to/definition.rb')
    TabTab::Completions::Gem.any_instance.expects(:load).with('/path/to/definition.rb').returns(true)
    @cli.expects(:config).returns({}).at_least(1)
    TabTab::Definition.register('test_app') do |c|
      c.flags :help, :h, "help"
      c.flags :extra, :x
    end
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

describe TabTab::CLI, "--gem GEM_NAME/PATH loads from a PATH within a gem to find definition" do
  before(:each) do
    @cli = TabTab::CLI.new
    TabTab::Completions::Gem.any_instance.expects(:load_gem_and_return_definitions_file).never
    TabTab::Completions::Gem.any_instance.expects(:gem_root_path).returns('/path/to/my_gem-1.0.0')
    TabTab::Completions::Gem.any_instance.expects(:load).with('/path/to/my_gem-1.0.0/lib/tabtab_definitions/definition.rb').returns(true)
    @cli.expects(:config).returns({}).at_least(1)
    TabTab::Definition.register('test_app') do |c|
      c.flags :help, :h, "help"
      c.flags :extra, :x
    end
    @stdout_io = StringIO.new
  end

  describe "to local completion definitions in file" do
    before(:each) do
      @cli.execute(@stdout_io, ['--gem', 'my_gem/lib/tabtab_definitions/definition.rb', 'test_app', '', 'test_app'])
    end
    it_should_print_completions
  end
  
  describe "with --alias ALIAS" do
    before(:each) do
      @cli.execute(@stdout_io, ['--gem', 'my_gem/lib/tabtab_definitions/definition.rb', '--alias', 'test_app', 'test', '', 'test'])
    end
    it_should_print_completions
  end
  
end

describe TabTab::CLI, "--file flag" do
  before(:each) do
    @cli = TabTab::CLI.new
    TabTab::Completions::File.any_instance.expects(:load).with('/path/to/definition.rb').returns(true)
    TabTab::Definition.register('test_app') do |c|
      c.flags :help, :h, "help"
      c.flags :extra, :x
    end
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

describe TabTab::CLI, "extracting tokens using ENV['COMP_LINE'] via extract_tokens_and_parse_options" do
  describe "with no tokens" do
    before(:each) do
      ENV['COMP_LINE'] = "myapp "
      @cli = TabTab::CLI.new
      @cli.extract_tokens_and_parse_options([])
    end

    it "should setup app_name" do
      @cli.app_name.should == "myapp"
    end
    
    it "should setup current_token" do
      @cli.current_token.should == ""
    end
    
    it "should setup previous_token" do
      @cli.previous_token.should == "myapp"
    end
  end

  describe "mid-way through a token" do
    before(:each) do
      ENV['COMP_LINE'] = "rake db:"
      @cli = TabTab::CLI.new
      @cli.extract_tokens_and_parse_options([])
    end

    it "should setup app_name" do
      @cli.app_name.should == "rake"
    end
    
    it "should setup current_token" do
      @cli.current_token.should == "db:"
    end
    
    it "should setup previous_token" do
      @cli.previous_token.should == "rake"
    end
  end
end