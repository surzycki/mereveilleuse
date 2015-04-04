@acceptance @js
Feature: Search Form
  Background: 
    Given I am logged in 
    And the application is setup
    And a search service is running for recommendation

  @wip
  Scenario: New Recommendation Search
    Given I am on the 'new search' page
    When I select 'Doctor' from profession_id on 'search form' 
    And I select 'Person' from patient_type_id on 'search form' 
    And I modify the 'search form' address with '6 rue gobert paris france'
    And I submit the form 
    Then I should be on the search success page
    And there should be an email queued
    
  Scenario: New Recommendation Search (validation error)
    Given I am on the 'new search' page
    When I modify the 'search form' address with '6 rue gobert paris france'
    And I submit the form
    Then I should see an error message

  Scenario: New Recommendation Search (bad address)
    Given I am on the 'new search' page
    And I modify the 'search form' address with 'bad address'
    And I submit the form
    Then I should see an error message
