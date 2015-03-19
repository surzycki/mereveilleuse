@acceptance @js
Feature: Recommendation Wizard 
  Background:
    Given I am logged in
    And the application is setup
  
  Scenario: Step One Success (Create Practitioner)
    Given I am on recommendation 'step one'
    When I modify the 'recommendation form' practitioner_name with 'Bob Jones'
    And I select 'Doctor' from profession_id on 'recommendation form'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with '6 rue Gobert'
    And I submit the form
    Then I should be on recommendation 'step two'
    And there should be a practitioner with fullname 'Bob Jones'
    And there should be a recommendation for practitioner with lastname 'Jones'
    #And the practitioner address is '6 rue Gobert'

  
  Scenario: Step One Success (Existing Practitioner)
    Given I am on recommendation 'step one'
    And a practitioner 'Homer Simpson' exists
    When I modify the 'recommendation form' practitioner_name with 'Homer Simpson'  
    And I select 'Doctor' from profession_id on 'recommendation form'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with '6 rue Gobert' 
    And I submit the form
    Then I should be on recommendation 'step two'
    And there should be a practitioner with fullname 'Homer Simpson'
    And there should be a recommendation for practitioner with lastname 'Simpson'
    #And the practitioner address is '6 rue Gobert'
       
  Scenario: Step One Fail
    Given I am on recommendation 'step one'
    When I modify the 'recommendation form' practitioner_name with 'Bob Jones'  
    And I submit the form
    Then I should not be on recommendation 'step two'
    And I should see an error message
    And there should not be a practitioner with fullname 'Bob Jones'
    And there should not be a recommendation for practitioner with lastname 'Jones'
    
  Scenario: Step Two Success
    Given recommendation wizard 'step one' is complete
    And I am on recommendation 'step two'
    When I choose 'wait_time' 1 on the 'recommendation form'
    And I choose 'availability' 1 on the 'recommendation form'
    And I choose 'bedside_manner' 1 on the 'recommendation form'
    And I choose 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should be on recommendation 'completed'
    And I should not see an error message

  Scenario: Step Two Fail
    Given recommendation wizard 'step one' is complete
    And I am on recommendation 'step two'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should see an error message

  Scenario: Completed Success (No Invite)
    Given recommendation wizard 'step two' is complete
    And I am on recommendation 'completed'

  Scenario: Completed Success (Invite)
    Given recommendation wizard 'step two' is complete
    And I am on recommendation 'completed'

