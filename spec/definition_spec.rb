require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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