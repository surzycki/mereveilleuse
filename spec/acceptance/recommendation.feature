@acceptance @js 
Feature: Recommendation Form
  Background: 
    Given I am logged in 
    And the application is setup

  
  Scenario: Recommend Unknown Practitioner
    Given I am on the 'new recommendation' page
    When I modify the 'recommendation form' practitioner_name with 'Bob Jones'
    And I select 'Doctor' from profession_id on 'recommendation form'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with '6 rue gobert paris france'
    And I choose 'wait_time' 1 on the 'recommendation form'
    And I choose 'availability' 1 on the 'recommendation form'
    And I choose 'bedside_manner' 1 on the 'recommendation form'
    And I choose 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should be on the 'show recommendation' page
    

  Scenario: Recommend Unknown Practitioner (validation error)
    Given I am on the 'new recommendation' page
    When I modify the 'recommendation form' practitioner_name with 'Bob Jones'
    And I select 'Doctor' from profession_id on 'recommendation form'
    And I submit the form
    Then I should see an error message

  Scenario: Recommend Unknown Practitioner (bad address)
    Given I am on the 'new recommendation' page
    When I modify the 'recommendation form' practitioner_name with 'Bob Jones'
    And I select 'Doctor' from profession_id on 'recommendation form'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with 'this is a bad address'
    And I choose 'wait_time' 1 on the 'recommendation form'
    And I choose 'availability' 1 on the 'recommendation form'
    And I choose 'bedside_manner' 1 on the 'recommendation form'
    And I choose 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should see an error message
    And recommendation_form_address should be marked as invalid

  Scenario: Recommend Known Practitioner (unmodified)
    Given I am on the 'new recommendation' page
    And a practitioner 'Homer Simpson' exists
    When I modify the 'recommendation form' practitioner_name with 'Homer Simpson'
    And I select 'Doctor' from profession_id on 'recommendation form'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with '6 rue gobert paris france'
    And I choose 'wait_time' 1 on the 'recommendation form'
    And I choose 'availability' 1 on the 'recommendation form'
    And I choose 'bedside_manner' 1 on the 'recommendation form'
    And I choose 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should be on the 'show recommendation' page
    
 
  Scenario: Recommend Known Practitioner (modified)
    Given I am on the 'new recommendation' page
    And a practitioner 'Homer Simpson' exists
    When I modify the 'recommendation form' practitioner_name with 'Homer Simpson'
    And I select 'Doctor' from profession_id on 'recommendation form'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with 'paris'
    And I choose 'wait_time' 1 on the 'recommendation form'
    And I choose 'availability' 1 on the 'recommendation form'
    And I choose 'bedside_manner' 1 on the 'recommendation form'
    And I choose 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should be on the 'show recommendation' page
    

  Scenario: Recommend Known Practitioner (bad address)
    Given I am on the 'new recommendation' page
    And a practitioner 'Homer Simpson' exists
    When I modify the 'recommendation form' practitioner_name with 'Homer Simpson'
    And I select 'Doctor' from profession_id on 'recommendation form'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with 'this is a bad address'
    And I choose 'wait_time' 1 on the 'recommendation form'
    And I choose 'availability' 1 on the 'recommendation form'
    And I choose 'bedside_manner' 1 on the 'recommendation form'
    And I choose 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should see an error message
    And recommendation_form_address should be marked as invalid
