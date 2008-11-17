Feature: Autocompletions for any 3rd-party application's options
  In order to minimise costs
  As a command-line application user
  I want auto-completions for the command-line applications I use
  
  Scenario: Install configured list of applications into bash completions
    Given a .tabtab.yml config file
    When run local executable 'install_tabtab' with arguments ''
    Then home file '.tabtab.sh' is created
    Then external completions are ready to be installed for applications: rails, test_app
  
  Scenario: Activate auto-completions for app, determine options and return all
    Given a .tabtab.yml config file
    And env variable $PATH includes fixture executables folder
    When run local executable 'tabtab' with arguments 'test_app'
    Then I should see a full list of options for 'test_app'
  
  Scenario: Activate auto-completions for app, determine partial options and return all
    Given a .tabtab.yml config file
    When run local executable 'tabtab' with arguments 'test_app --'
    Then I should see a partial list of options for 'test_app' starting with '--'

  
