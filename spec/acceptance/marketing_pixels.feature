@acceptance @js
Feature: Marketing Pixels
  Background: 
    Given the application is setup
    And I am logged in
    
  Scenario: New Recommendation
    Given I am on the 'new recommendation' page
    Then the Facebook recommendation conversion pixel should be fired
    And the Facebook landing conversion pixel should not be fired

  Scenario: New Search 
    Given I am on the 'new search' page
    Then the Facebook recommendation conversion pixel should not be fired
    And the Facebook landing conversion pixel should not be fired

  Scenario: New Registration 
    Given I am on the 'new registration' page
    Then the Facebook recommendation conversion pixel should not be fired
    And the Facebook landing conversion pixel should be fired
    
