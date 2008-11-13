Given %r{^a .ezy_auto_completions.yml config file} do
  Given "a safe folder"
  in_home_folder do
    config = { 
      'external' => { 
        '-h' => %w[rails rake], 
        '-?' => [] 
      }
    }
    File.open('.ezy_auto_completions.yml', 'w') do |f|
      f << config.to_yaml
    end
  end
end

Given %r{^expecting bash completions for applications: (.*)$} do |app_list|
  self.class.send :include, Mocha::Standalone
  mocha_setup
  # TODO - how to enable expects so it captures stuff??????
  
  app_list.split(/,\s*/).each do |app|
    InstallEzyAutoCompletions::CLI.any_instance.expects(:sh).with("complete -o default -C ezy_auto_completions #{app}").returns(true)
  end
end

# Then %r{^bash completions are installed for each application$} do
#   mocha_verify
# end