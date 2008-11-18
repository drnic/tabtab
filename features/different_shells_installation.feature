Feature: Can install tabtab autocompletions for multiple shells
  In order to minimize cost of having autocompletion scripts for my personal shell
  As a Unix command line user
  I want any tabtab completion definition to work on my shell

  Scenario: I use bash shell
    Given a bash shell
    And a .tabtab.yml config file
    When run local executable 'install_tabtab' with arguments ''
    Then home file '.tabtab.bash' is created
    Then external completions are ready to be installed for applications: rails, test_app
  
  Scenario: I use fish shell
    Given a fish shell
    And a .tabtab.yml config file
    When run local executable 'install_tabtab' with arguments ''
    Then home file '.tabtab.fish' is created
    Then external completions are ready to be installed for applications: rails, test_app

  Scenario: I use ksh shell
    Given a ksh shell
    And a .tabtab.yml config file
    When run local executable 'install_tabtab' with arguments ''
    Then home file '.tabtab.ksh' is created
    Then external completions are ready to be installed for applications: rails, test_app

