@acceptance @js 
Feature: Recommendation Email
  Background: 
    Given the application is setup 
    And I am logged in  
    And I goto the 'new search' page
    And I select 'Doctor' from profession_id on 'search form' 
    And I select 'Person' from patient_type_id on 'search form' 
    And I modify the 'search form' address with '6 rue gobert paris france'
    And I submit the form and execute async jobs
    
  @wip
  Scenario: Unsubscribe from search email
    Given I open email sent to 'user.person@example.com'
    When I click 'unsubscribe-search' in the email
    Then I should be on the 'unsubscribe search' page for the search
    And the search should have 'true' for 'canceled?'
    And there should be an email of type 'reciprocate' queued


  Scenario: Unsubscribe from account
    Given I open email sent to 'user.person@example.com'
    When I click 'unsubscribe-account' in the email
    Then I should be on the 'unsubscribe account' page for the user
    And the user should have 'true' for 'unsubscribed?'


  Scenario: Recommendation Email Goto Recommendation Page
    Given I open email sent to 'user.person@example.com'
    When I click 'new-recomendation' in the email
    Then I should be on the 'new recommendation' page

