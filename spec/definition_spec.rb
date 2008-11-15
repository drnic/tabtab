require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "filtered_completions for" do
  describe EzyAutoCompletions::Definition::Root, "with flags and commands can return all terms for autocomplete" do
    before(:each) do
      @definitions = EzyAutoCompletions::Definition::Root.named('myapp') do |c|
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

    it "should return ['run', 'stop', '--some_flag', '-s'] as root-level completion options unfiltered" do
      @definitions.filtered_completions('').should == ['run', 'stop', '--some_flag', '-s', '--flag_and_value']
    end

    it "should return ['--some_flag', '-s'] as root-level completion options filtered by '-'" do
      @definitions.filtered_completions('-').should == ['--some_flag', '-s', '--flag_and_value']
    end

  end

  describe EzyAutoCompletions::Definition::Base, "for default values" do
    before(:each) do
      @definitions = EzyAutoCompletions::Definition::Root.named('myapp') do |c|
        c.command :run do
          %w[aaaa bbbb cccc]
        end
        c.command :stop do |stop|
          stop.default do
            %w[aaaa bbbb cccc]
          end
        end
        c.flag :flag_and_value do
          %w[xxx yyy zzz]
        end
      end
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

    it "should find ['aaaa', etc] for the flag via a block" do
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