Given /^disable short flags$/ do
  in_home_folder do
    config = YAML.load(File.read('.tabtab.yml'))
    config['shortflags'] = 'disable'
    File.open('.tabtab.yml', 'w') do |f|
      f << config.to_yaml
    end
  end
end

