Feature: User can reuse completions for their own aliases
  In order to minimize cost of duplicating definitions
  As a command line user that defines aliases
  I want the tabtab completions for the unaliased application to work for my alias

  Scenario: An alias maps directly to an app name, that has an existing tabtab definition
    Given an alias 'gen' directly to an application 'script/generate'
    When event
    Then outcome
  

    Scenario: An alias maps to an app name plus arguments
    Given an alias 'gco' indirectly to an application call 'git commit'
    When event
    Then outcome
  