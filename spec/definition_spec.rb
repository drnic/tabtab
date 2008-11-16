require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

def setup_definitions
  @definitions = EzyAutoCompletions::Definition::Root.named('myapp') do |c|
    c.command :simple
    c.command :run do
      %w[aaaa bbbb cccc]
    end
    c.command :stop do |stop|
      stop.default do
        %w[aaaa bbbb cccc]
      end
    end
    c.flags :some_flag, :s
    c.flag :flag_and_value do
      %w[xxx yyy zzz]
    end
  end
end

describe EzyAutoCompletions::Definition::Root, "can parse current cmd-line expression and find active definition" do
  before(:each) do
    setup_definitions
  end

  it "should parse cmd-line 'myapp' and return self/root of definition" do
    @definitions.find_active_definition_for_last_token('myapp').should == @definitions
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

  it "should parse cmd-line 'myapp run dummy_value' and return the run command definition" do
    @definitions.find_active_definition_for_last_token('dummy_value').should == @definitions
  end

  it "should parse cmd-line 'myapp --some_flag run' and return the run command definition" do
    @definitions.find_active_definition_for_last_token('run').should == @definitions['run']
  end
end

describe "tokens_consumed for various" do
  describe EzyAutoCompletions::Definition::Base, "definitions" do
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
  describe EzyAutoCompletions::Definition::Root, "with flags and commands can return all terms for autocomplete" do
    before(:each) do
      setup_definitions
    end

    it "should return ['run', 'stop', '--some_flag', '-s'] as root-level completion options unfiltered" do
      @definitions.filtered_completions('').should == ['simple', 'run', 'stop', '--some_flag', '-s', '--flag_and_value']
    end

    it "should return ['--some_flag', '-s'] as root-level completion options filtered by '-'" do
      @definitions.filtered_completions('-').should == ['--some_flag', '-s', '--flag_and_value']
    end

  end

  describe EzyAutoCompletions::Definition::Base, "for default values" do
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

describe EzyAutoCompletions::Definition, "with invalid number of block args" do
  it "should raise an error for invalid root block definition" do
    lambda do
      EzyAutoCompletions::Definition::Root.named('myapp') do |c1, c2|
      end
    end.should raise_error(EzyAutoCompletions::Definition::InvalidDefinitionBlockArguments)
  end

  it "should raise an error for invalid command block definition" do
    lambda do
      EzyAutoCompletions::Definition::Root.named('myapp') do |c|
        c.command :stop do |arg1, arg2|
        end
      end
    end.should raise_error(EzyAutoCompletions::Definition::InvalidDefinitionBlockArguments)
  end
end