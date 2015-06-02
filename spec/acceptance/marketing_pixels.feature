@acceptance @js
Feature: Marketing Pixels
  Background: 
    Given the application is setup
    And I am logged in
    
  Scenario: New Recommendation
    Given I goto the 'new recommendation' page
    Then the Facebook 'Mereveilleuse - Registration' conversion pixel should be fired
    And the Facebook 'Mereveilleuse - Landing' conversion pixel should not be fired

  Scenario: New Search 
    Given I goto the 'new search' page
    Then the Facebook 'Mereveilleuse - Registration' conversion pixel should not be fired
    And the Facebook 'Mereveilleuse - Landing' conversion pixel should not be fired

  Scenario: New Registration 
    Given I goto the 'new registration' page
    Then the Facebook 'Mereveilleuse - Registration' conversion pixel should not be fired
    And the Facebook 'Mereveilleuse - Landing' conversion pixel should be fired
    
