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
