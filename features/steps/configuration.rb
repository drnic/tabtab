Given /^disable short flags$/ do
  in_home_folder do
    config = YAML.load(File.read('.tabtab.yml'))
    config['shortflags'] = 'disable'
    File.open('.tabtab.yml', 'w') do |f|
      f << config.to_yaml
    end
  end
end

Given /^alias 'test' to existing 'test_app'$/ do
  in_home_folder do
    config = YAML.load(File.read('.tabtab.yml'))
    config['aliases'] = { 'test' => 'test_app' }
    File.open('.tabtab.yml', 'w') do |f|
      f << config.to_yaml
    end
  end
end
