@acceptance @js @wip 
Feature: Facebook Events
  Background: 
    Given the application is setup
    And I am logged in
    
  
  Scenario: New Recommendation
    Given I am on the 'new recommendation' page
    And take a screenshot
    Then the Facebook conversion pixel should be fired

  Scenario: New Search 
    Given I am on the 'new search' page
    And take a screenshot
    Then the Facebook conversion pixel should not be fired
  
  Scenario: New Registration 
    Given I am on the 'new registration' page
    And take a screenshot
    Then the Facebook conversion pixel should not be fired
    
