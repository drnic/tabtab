Feature: Autocompletions for app via an explicit definition file
  In order to minimise costs
  As a command-line application user
  I want my own autocompletions for an app, rather than those given by default
  
  Scenario: Trigger autocompletions where the definition is in a specific file
    Given a file 'my_definitions.rb' containing completion definitions
    When run local executable 'tabtab' with arguments '--file my_definitions.rb test_app "" test_app'
    Then I should see a full list of options for 'test_app'
  
  
