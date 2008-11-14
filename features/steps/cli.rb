Given %r{^a .ezy_auto_completions.yml config file} do
  Given "a safe folder"
  in_home_folder do
    config = { 
      'external' => { 
        '-h' => %w[rails test_app], 
        '-?' => [] 
      }
    }
    File.open('.ezy_auto_completions.yml', 'w') do |f|
      f << config.to_yaml
    end
  end
end

Then %r{^bash completions are ready to be installed for applications: (.*)$} do |app_list|
  contents = File.read(".ezy_auto_completion.sh")
  app_list.each do |app|
    contents.should =~ /complete -o default -C ezy_auto_completions #{app}/
  end
end