Feature: Development processes of newgem itself (rake tasks)

  As a Newgem maintainer or contributor
  I want rake tasks to maintain and release the gem
  So that I can spend time on the tests and code, and not excessive time on maintenance processes
    
  Scenario: Generate RubyGem
    Given this project is active project folder
    And 'pkg' folder is deleted
    When task 'rake gem' is invoked
    Then project folder 'pkg' is created
    And project file with name matching 'pkg/*.gem' is created else you should run "rake manifest" to fix this
    And gem spec key 'rdoc_options' contains /--mainREADME.rdoc/

  Scenario: Generate .tabtab.bash using dev tabtab CLI instead of gem version
    Given a .tabtab.yml config file
    When run local executable 'install_tabtab' with arguments '--development'
    Then home file '.tabtab.bash' is created
    And contents of home file '.tabtab.bash' does match /bin\/tabtab/
