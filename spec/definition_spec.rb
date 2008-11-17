require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

def setup_definitions
  @definitions = TabTab::Definition::Root.named('myapp') do |c|
    c.command :simple
    c.command :run do
      %w[aaaa bbbb cccc]
    end
    c.command :stop do |stop|
      stop.default do
        %w[aaaa bbbb cccc]
      end
    end
    c.command :multi do |multi|
      multi.command :first
      multi.command :last do
        %w[foo bar tar]
      end
    end
    c.flags :some_flag, :s
    c.flag :flag_and_value do
      %w[xxx yyy zzz]
    end
  end
end

describe TabTab::Definition, "register a complete definition" do
  before(:each) do
    TabTab::Definition::Root.expects(:named).with('someapp').returns(mock)
    TabTab::Definition.register('someapp')
  end

  it "should register application" do
    TabTab::Definition.registrations.should be_has_key('someapp')
  end
end

describe TabTab::Definition, "select definition via [app_name]" do
  before(:each) do
    TabTab::Definition.expects(:registrations).returns({"someapp" => mock})
  end
  
  it "should find definition via Definition[someapp]" do
    TabTab::Definition['someapp'].should_not be_nil
  end
end

describe TabTab::Definition::Root, "extract_completions" do
  before(:each) do
    setup_definitions
  end
  
  it "should initially return list of all root flags and commands" do
    @definitions.extract_completions('someapp', '').should == ['multi', 'run', 'simple', 'stop', '--flag_and_value', '--some_flag', '-s']
  end

  it "should return list of all root flags and commands after simple command" do
    @definitions.extract_completions('simple', '').should == ['multi', 'run', 'simple', 'stop', '--flag_and_value', '--some_flag', '-s']
  end

  it "should return list of all root flags and commands after simple flag" do
    @definitions.extract_completions('--some_flag', '').should == ['multi', 'run', 'simple', 'stop', '--flag_and_value', '--some_flag', '-s']
  end

  it "should return list of all root flags and commands" do
    @definitions.extract_completions('someapp', '--').should == ['--flag_and_value', '--some_flag']
  end

  it "should return list of flags and commands for a nested command" do
    @definitions.extract_completions('multi', '').should == ['first', 'last']
  end

  it "should return list of multi's flags and commands after a simple command/flag" do
    @definitions.extract_completions('first', '').should == ['first', 'last']
  end
end

describe TabTab::Definition::Default, "can yield with different number of arguments" do
  before(:each) do
    @definitions = TabTab::Definition::Root.named('myapp') do |c|
      c.command :zero do |zero|
        zero.default { %w[zero] }
      end
      c.command :one do |one|
        one.default { |current| ['one', current] }
      end
    end
  end
  
  it "should run default blocks with zero arguments" do
    tokens = @definitions.extract_completions("zero", "")
    tokens.should == ['zero']
  end
  
  it "should run default blocks with one arguments and pass current token as argument" do
    tokens = @definitions.extract_completions('one', 'o')
    tokens.should == ['o', 'one']
  end
  
end
describe TabTab::Definition::Root, "can parse current cmd-line expression and find active definition" do
  before(:each) do
    setup_definitions
  end

  it "should parse cmd-line 'myapp' and return nil" do
    @definitions.find_active_definition_for_last_token('myapp').should be_nil
  end
  
  it "should parse cmd-line 'myapp simple' and return the command definition" do
    @definitions.find_active_definition_for_last_token('simple').should == @definitions['simple']
  end
  
  it "should parse cmd-line 'myapp run' and return the command definition" do
    @definitions.find_active_definition_for_last_token('run').should == @definitions['run']
  end
  
  it "should parse cmd-line 'myapp --some_flag' and return the flag definition" do
    @definitions.find_active_definition_for_last_token('--some_flag').should == @definitions['some_flag']
  end

  it "should parse cmd-line 'myapp -s' and return the flag definition" do
    @definitions.find_active_definition_for_last_token('-s').should == @definitions['some_flag']
  end

  it "should parse cmd-line 'myapp run dummy_value' and return nil" do
    @definitions.find_active_definition_for_last_token('dummy_value').should be_nil
  end

  it "should parse cmd-line 'myapp multi' and return the multi command definition" do
    @definitions.find_active_definition_for_last_token('multi').should == @definitions['multi']
  end

  it "should parse cmd-line 'myapp multi first' and return the multi command definition" do
    @definitions.find_active_definition_for_last_token('first').should == @definitions['multi']['first']
  end

  it "should parse cmd-line 'myapp multi last' and return the command definition" do
    @definitions.find_active_definition_for_last_token('last').should == @definitions['multi']['last']
  end

  it "should parse cmd-line 'myapp multi last foo' and return nil" do
    @definitions.find_active_definition_for_last_token('foo').should be_nil
  end

  it "should parse cmd-line 'myapp --some_flag run' and return the run command definition" do
    @definitions.find_active_definition_for_last_token('run').should == @definitions['run']
  end
end

# TODO - not using these functionality as only given last_token by complete API - remove it??
describe "tokens_consumed for various" do
  describe TabTab::Definition::Base, "definitions" do
    before(:each) do
      setup_definitions
    end
    
    it "should consume 1 token for a simple command" do
      @definitions['simple'].tokens_consumed.should == 1
    end
    
    it "should consume 2 tokens for a command with value block" do
      @definitions['run'].tokens_consumed.should == 2
    end
    
    it "should consume 1 token for a command with a default value block" do
      @definitions['stop'].tokens_consumed.should == 2
    end
    
    it "should consume 1 token for a simple flag" do
      @definitions['some_flag'].tokens_consumed.should == 1
    end
    
    it "should consume 2 token for a flag with value block" do
      @definitions['flag_and_value'].tokens_consumed.should == 2
    end
  end
end
describe "filtered_completions for" do
  describe TabTab::Definition::Root, "with flags and commands can return all terms for autocomplete" do
    before(:each) do
      setup_definitions
    end

    it "should return ['simple', 'run', 'stop', 'multi', '--some_flag', '-s'] as root-level completion options unfiltered" do
      @definitions.filtered_completions('').should == ['simple', 'run', 'stop', 'multi', '--some_flag', '-s', '--flag_and_value']
    end

    it "should return ['--some_flag', '-s'] as root-level completion options filtered by '-'" do
      @definitions.filtered_completions('-').should == ['--some_flag', '-s', '--flag_and_value']
    end
    
    it "should return ['aaaa', et] for 'run' command" do
      @definitions['run'].filtered_completions('').should ==  %w[aaaa bbbb cccc]
    end

    it "should return ['first', 'last'] for 'multi' command" do
      @definitions['multi'].filtered_completions('').should == ['first', 'last']
    end

  end

  describe TabTab::Definition::Base, "for default values" do
    before(:each) do
      setup_definitions
    end
    
    it "should find ['aaaa', etc] for the run command via a block" do
      @run = @definitions['run']
      @run.definition_type.should == :command
      @run.filtered_completions('').should == %w[aaaa bbbb cccc]
    end

    it "should find ['aaaa', etc] for the stop command via a default definition" do
      @stop = @definitions['stop']
      @stop.filtered_completions('').should == %w[aaaa bbbb cccc]
    end

    it "should find ['xxx', etc] for the flag via a block" do
      @flag = @definitions['--flag_and_value']
      @flag.filtered_completions('').should == %w[xxx yyy zzz]
    end
  end
end

describe TabTab::Definition, "with invalid number of block args" do
  it "should raise an error for invalid root block definition" do
    lambda do
      TabTab::Definition::Root.named('myapp') do |c1, c2|
      end
    end.should raise_error(TabTab::Definition::InvalidDefinitionBlockArguments)
  end

  it "should raise an error for invalid command block definition" do
    lambda do
      TabTab::Definition::Root.named('myapp') do |c|
        c.command :stop do |arg1, arg2|
        end
      end
    end.should raise_error(TabTab::Definition::InvalidDefinitionBlockArguments)
  end
end

describe TabTab::Definition, "should not yield blocks upon creation" do
  before(:each) do
    @normal_block_was_run, @default_block_was_run, @root_default_block_was_run = 0, 0, 0
    @definitions = TabTab::Definition::Root.named('myapp') do |c|
      c.command :run do
        @normal_block_was_run += 1
      end
      c.command :stop do |stop|
        stop.default do
          @default_block_was_run += 1
        end
      end
      c.default do
        @root_default_block_was_run += 1
      end
    end
  end
  it "should not yield block upon creation" do
    @normal_block_was_run.should == 0
    @default_block_was_run.should == 0
  end
  
  it "should not yield root value block" do
    @root_default_block_was_run.should == 0
  end
  
  it "should not yield block upon #extract_completions" do
    @definitions.extract_completions('myapp', '')
    @normal_block_was_run.should == 0
    @default_block_was_run.should == 0
  end
end

describe TabTab::Definition, "should not yield command blocks when gathering root options" do
  before(:each) do
    @normal_block_was_run, @default_block_was_run, @root_default_block_was_run = 0, 0, 0
    @definitions = TabTab::Definition::Root.named('myapp') do |c|
      c.command :run do
        @normal_block_was_run += 1
      end
      c.command :stop do |stop|
        stop.default do
          @default_block_was_run += 1
        end
      end
      c.default do
        @root_default_block_was_run += 1
      end
    end
    @definitions.extract_completions('myapp', '')
  end
  it "should not yield block upon creation" do
    @normal_block_was_run.should == 0
    @default_block_was_run.should == 0
  end
  
  it "should yield root value block" do
    @root_default_block_was_run.should == 1
  end
  
  it "should not yield block upon #extract_completions" do
    @definitions.extract_completions('myapp', '')
    @normal_block_was_run.should == 0
    @default_block_was_run.should == 0
  end
  
  it "should be failing in here somewhere - in production these blocks are being run!"
end
