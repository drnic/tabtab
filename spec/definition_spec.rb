require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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
    @all_possibles = ['run', 'stop', '--some_flag', '-s', '--flag_and_value']
  end
  
  it "should return ['run', 'stop', '--some_flag', '-s'] as root-level completion options" do
    @definitions.unfiltered_completions.should == @all_possibles
  end
  
  it "should return ['run', 'stop', '--some_flag', '-s'] as root-level completion options unfiltered" do
    @definitions.filtered_completions('').should == @all_possibles
  end

  it "should return ['--some_flag', '-s'] as root-level completion options filtered by '-'" do
    @definitions.filtered_completions('-').should == ['--some_flag', '-s', '--flag_and_value']
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