Feature: Do not display short flags (-p) within lists of completions options
  In order to reduce cost of scanning through lists of completion options
  As a tabtab user
  I want to be able to disable short flags and never see them

  Scenario: Explicitly disable short flags via the config file for definitions
    Given a .tabtab.yml config file
    And a file 'my_definitions.rb' containing completion definitions
    And disable short flags
    When run local executable 'tabtab' with arguments '--file my_definitions.rb test_app "" test_app'
    Then I should not see any short form flags
  
  Scenario: Explicitly disable short flags via the config file for externals
    Given a .tabtab.yml config file
    And disable short flags
    And env variable $PATH includes fixture executables folder
    When run local executable 'tabtab' with arguments '--external test_app "" test_app'
    Then I should not see any short form flags

