Feature: Autocompletions for any 3rd-party application's options
  In order to minimise costs
  As a command-line application user
  I want auto-completions for the command-line applications I use
  
  Scenario: Install configured list of applications into bash completions
    Given a .ezy_auto_completions.yml config file
    And expecting bash completions for applications: rails, test_app
    When run local executable 'install_ezy_auto_completions' with arguments ''
    Then bash completions are installed for each application
  
  Scenario: Activate auto-completions for app, determine options and return all
    Given a .ezy_auto_completions.yml config file
    When run local executable 'ezy_auto_completions' with arguments 'test_app'
    Then I should see a full list of options for 'test_app'
  
  Scenario: Activate auto-completions for app, determine partial options and return all
    Given a .ezy_auto_completions.yml config file
    When run local executable 'ezy_auto_completions' with arguments 'test_app --'
    Then I should see a partial list of options for 'test_app' starting with '--'

  
