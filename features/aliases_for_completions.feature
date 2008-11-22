Feature: User can reuse completions for their own aliases
  In order to minimize cost of duplicating definitions
  As a command line user that defines aliases
  I want the tabtab completions for the unaliased application to work for my alias

  Scenario: Add alias for existing completions
    Given a .tabtab.yml config file
    And alias 'test_alias' to existing 'test_app'
    When run local executable 'install_tabtab' with arguments ''
    Then home file '.tabtab.bash' is created
    And contents of home file '.tabtab.bash' does match /test_alias/
    And contents of home file '.tabtab.bash' does match /--file /path/to/file.rb --alias test_app/

  Scenario: An alias maps directly to an app name, that has an existing tabtab definition
    Given an alias 'test' directly to an application 'test_app'
    Given a file 'my_definitions.rb' containing completion definitions
    When run local executable 'tabtab' with arguments '--file my_definitions.rb --alias test_app test "" test'
    Then I should see a full list of options for 'test_app'
  

  Scenario: An alias maps to an app name plus arguments
    Given an alias 'test' directly to an application 'test_app -x'
    Given a file 'my_definitions.rb' containing completion definitions
    When run local executable 'tabtab' with arguments '--file my_definitions.rb --alias "test_app -x" test "" test'
    Then I should see a full list of options for 'test_app'
  