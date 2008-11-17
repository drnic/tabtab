Feature: Autocompletions for app via an explicit definition file
  In order to minimise costs
  As a command-line application user
  I want my own autocompletions for an app, rather than those given by default
  
  Scenario: Add completions within explicit files
    Given a .tabtab.yml config file
    When run local executable 'install_tabtab' with arguments ''
    Then home file '.tabtab.sh' is created
    Then file completions are ready to be installed for applications test_app in file /path/to/file.rb
  
  Scenario: Trigger autocompletions where the definition is in a specific file
    Given a file 'my_definitions.rb' containing completion definitions
    When run local executable 'tabtab' with arguments '--file my_definitions.rb test_app "" test_app'
    Then I should see a full list of options for 'test_app'
  
  
