Given /^env variable \$PATH includes fixture executables folder$/ do
  ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + "/../../spec/fixtures/bin")}:#{ENV['PATH']}"
end

Then /^I should see a full list of options for 'test_app'$/ do
  actual_output = File.read(File.join(@tmp_root, "executable.out"))
  expected_output = %w[banana drink unlock --extra --help -h -x].join("\n")
  expected_output.should == actual_output.strip
end

Then /^I should see a partial list of options for 'test_app' starting with '--'$/ do
  actual_output = File.read(File.join(@tmp_root, "executable.out"))
  expected_output = %w[--extra --help].join("\n")
  expected_output.should == actual_output.strip
end
