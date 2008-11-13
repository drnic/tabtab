Feature: Autocompletions for any 3rd-party application's options
  In order to minimise costs
  As a command-line application user
  I want auto-completions for the command-line applications I use
  
  Scenario: Install configured list of applications into bash completions
    Given a .ezy_auto_completions.yml config file
    When run local executable 'install_ezy_auto_completions' with arguments ''
    Then bash completions are installed for each application
  

  
