Feature: Discover completions config script in installed RubyGems
  In order to minimize cost of using completions
  As a user of RubyGems that contain completions config scripts
  I want RubyGems executables to be automatically enabled with auto-completions for my shell
  
  Scenario: Find and add completions for rubygems' executables
    Given a user's RubyGems gem cache
    And a RubyGem 'my_app' with executable 'test_app' with autocompletions
    When run local executable 'install_ezy_auto_completions' with arguments ''
    Then home file '.ezy_auto_completions.sh' is created
    Then bash completions are ready to be installed for applications: bar
  

  
