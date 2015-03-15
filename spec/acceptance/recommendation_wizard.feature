@acceptance
Feature: Recommendation Wizard 
  Background:
    Given I am logged in
    And the application is setup
  
  Scenario: Step One Success (Create Practitioner)
    Given I am on 'recommendation step one'
    When I modify the 'RecommendationForm' practitioner_name with 'Bob Jones'
    And I select 'Doctor' from 'ProfessionId' on 'RecommendationForm'
    And I select 'Person' from 'PatientTypeId' on 'RecommendationForm' 
    And I modify the 'RecommendationForm' address with '6 rue Gobert'
    And I submit the form
    Then I should be on 'recommendation step two'
    And there is 1 practitioners
    And there is 1 recommendation
    #And the practitioner address is '6 rue Gobert'

  Scenario: Step One Success (Existing Practitioner)
    Given I am on 'recommendation step one'
    And a practitioner 'Homer Simpson' exists
    When I modify the 'RecommendationForm' practitioner_name with 'Homer Simpson'  
    And I select 'Doctor' from profession_id on 'RecommendationForm'
    And I select 'Person' from patient_type_id on 'RecommendationForm' 
    And I modify the 'RecommendationForm' address with '6 rue Gobert' 
    And I submit the form
    Then I should be on 'recommendation step two'
    And there is 1 practitioner
    And there is 1 recommendation
    #And the practitioner address is '6 rue Gobert'
       

  Scenario: Step One Fail
    Given I am on 'recommendation step one'
    When I modify the 'RecommendationForm' practitioner_name with 'Bob Jones'  
    And I submit the form
    Then I should not be on 'recommendation step two'
    And I see an error message
    And there are 0 practitioners
    And there are 0 recommendations
    

  Scenario: Step Two Success
    Given recommendation wizard step one is complete
    And I am on 'recommendation step two'
    

  Scenario: Step Two Fail