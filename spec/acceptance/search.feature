@acceptance @js @wip
Feature: Search Form
  Background: 
    Given the application is setup
    And I am logged in 
    
  Scenario: New Recommendation Search
    Given I goto the 'new search' page
    When I select 'Doctor' from profession_id on 'search form' 
    And I select 'Person' from patient_type_id on 'search form' 
    And I modify the 'search form' address with '6 rue gobert paris france'
    And I submit the form and execute async jobs
    Then I should be on the 'search' page
    And I open email sent to 'user.person@example.com'
    And I should see 'Les Doctors du 6 Rue Gobert, 75011, Paris' in the subject line
  

  Scenario: New Recommendation Search (validation error)
    Given I goto the 'new search' page
    When I modify the 'search form' address with '6 rue gobert paris france'
    And I submit the form
    Then I should see an error message
    And there should not be a 'recommendations email' queued


  Scenario: New Recommendation Search (bad address)
    Given I goto the 'new search' page
    And I modify the 'search form' address with 'bad address'
    And I submit the form
    Then I should see an error message
    And there should not be a 'recommendations email' queued

  
  Scenario: Expanded Recommendation Search
    Given I goto the 'new search' page
    When I select 'Doctor' from profession_id on 'search form' 
    And I select 'Another Person' from patient_type_id on 'search form' 
    And I modify the 'search form' address with '6 rue gobert paris france'
    And I submit the form and execute async jobs
    Then I should be on the 'search' page
    And I open email sent to 'user.person@example.com'
    And I should see 'Les Doctors du 6 Rue Gobert, 75011, Paris' in the subject line
    And I should see "Il ne s’agit pas d’une consultation destinée à another person mais à person" in the email

  
  Scenario: Expanded Recommendation Search (no results)
    Given there are no relevant recommendations
    And I goto the 'new search' page
    When I select 'Doctor' from profession_id on 'search form' 
    And I select 'Another Person' from patient_type_id on 'search form' 
    And I modify the 'search form' address with '6 rue gobert paris france'
    And I submit the form and execute async jobs
    Then I should be on the 'search' page
    And an email should not have been sent to 'user.person@example.com'