Given %r{^a .tabtab.yml config file} do
  Given "a safe folder"
  in_home_folder do
    config = { 
      'external' => { 
        '-h' => %w[rails test_app], 
        '-?' => [] 
      },
      'files' => { 
        '/path/to/file.rb' => 'test_app' 
      }
    }
    File.open('.tabtab.yml', 'w') do |f|
      f << config.to_yaml
    end
  end
end

Given /^a file '(.*)' containing completion definitions$/ do |file|
  Given "a safe folder"
  in_project_folder do
    File.open(file, "w") do |f|
      f << <<-RUBY.gsub(/^        /,'')
        TabTab::Definition.register('test_app') do |c|
          c.flags :help, :h, "help"
          c.flags :extra, :x
        end
      RUBY
    end
  end
end

Then %r{^external completions are ready to be installed for applications: (.*)$} do |app_list|
  in_home_folder do
    contents = File.read(".tabtab.sh")
    app_list.split(/,\s*/).each do |app|
      contents.should =~ /complete -o default -C 'tabtab --external' #{app}/
    end
  end
end

Then %r{^gem completions are ready to be installed for applications (.*) in gem (.*)$} do |app_list, gem_name|
  in_home_folder do
    contents = File.read(".tabtab.sh")
    app_list.split(/,\s*/).each do |app|
      contents.should =~ /complete -o default -C 'tabtab --gem #{gem_name}' #{app}/
    end
  end
end

Then %r{^file completions are ready to be installed for applications (.*) in file (.*)$} do |app_list, file_name|
  in_home_folder do
    contents = File.read(".tabtab.sh")
    app_list.split(/,\s*/).each do |app|
      contents.should =~ /complete -o default -C 'tabtab --file #{file_name}' #{app}/
    end
  end
end

