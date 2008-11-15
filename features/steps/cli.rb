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

Then %r{^(\w+) completions are ready to be installed for applications: (.*)$} do |type, app_list|
  in_home_folder do
    contents = File.read(".ezy_auto_completions.sh")
    app_list.split(/,\s*/).each do |app|
      contents.should =~ /complete -o default -C 'ezy_auto_completions --#{type}' #{app}/
    end
  end
end