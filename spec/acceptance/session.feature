@acceptance 
Feature: Session
  Background: 
    Given the application is setup
    And a user exists

  Scenario: Unregistered User
    Given I am unregistered
    And I am on the 'new session' page
    Then I should be on the 'new registration' page

  Scenario: Registered User
    Given I am registered
    And I am on the 'new session' page
    Then I should be on the 'new search' page