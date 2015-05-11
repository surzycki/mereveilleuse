@acceptance @js 
Feature: Recommendation Form
  Background: 
    Given the application is setup  
    And I am logged in
    
  Scenario: Recommend NEW Practitioner
    Given I goto the 'new recommendation' page
    When I modify the 'recommendation form' practitioner_name with 'Bob Jones'
    And I modify the 'recommendation form' profession_name with 'Doctor'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with '6 rue gobert paris france'
    And I rate 'wait_time' 1 on the 'recommendation form'
    And I rate 'availability' 1 on the 'recommendation form'
    And I rate 'bedside_manner' 1 on the 'recommendation form'
    And I rate 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should be on the 'recommendation' show page
    
  
  Scenario: Recommend NEW Practitioner (new profession)
    Given I goto the 'new recommendation' page
    When I modify the 'recommendation form' practitioner_name with 'Bob Jones'
    And I modify the 'recommendation form' profession_name with 'New Type of Doctor'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with '6 rue gobert paris france'
    And I rate 'wait_time' 1 on the 'recommendation form'
    And I rate 'availability' 1 on the 'recommendation form'
    And I rate 'bedside_manner' 1 on the 'recommendation form'
    And I rate 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should be on the 'recommendation' show page


  Scenario: Recommend NEW Practitioner (validation error)
    Given I goto the 'new recommendation' page
    When I modify the 'recommendation form' practitioner_name with 'Bob Jones'
    And I modify the 'recommendation form' profession_name with 'Doctor'
    And I submit the form
    Then I should see an error message


  Scenario: Recommend NEW Practitioner (bad address)
    Given I goto the 'new recommendation' page
    When I modify the 'recommendation form' practitioner_name with 'Bob Jones'
    And I modify the 'recommendation form' profession_name with 'Doctor'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with 'this is a bad address'
    And I rate 'wait_time' 1 on the 'recommendation form'
    And I rate 'availability' 1 on the 'recommendation form'
    And I rate 'bedside_manner' 1 on the 'recommendation form'
    And I rate 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should see an error message
    And recommendation_form_address should be marked as invalid


  Scenario: Recommend EXISTING Practitioner (no change)
    Given I goto the 'new recommendation' page
    And a practitioner 'Homer Simpson' exists
    When I modify the 'recommendation form' practitioner_name with 'Homer Simpson'
    And I modify the 'recommendation form' profession_name with 'Doctor'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with '6 rue gobert paris france'
    And I rate 'wait_time' 1 on the 'recommendation form'
    And I rate 'availability' 1 on the 'recommendation form'
    And I rate 'bedside_manner' 1 on the 'recommendation form'
    And I rate 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should be on the 'recommendation' show page
    
 
  Scenario: Recommend EXISTING Practitioner (new address)
    Given I goto the 'new recommendation' page
    And a practitioner 'Homer Simpson' exists
    When I modify the 'recommendation form' practitioner_name with 'Homer Simpson'
    And I modify the 'recommendation form' profession_name with 'Doctor'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with 'paris'
    And I rate 'wait_time' 1 on the 'recommendation form'
    And I rate 'availability' 1 on the 'recommendation form'
    And I rate 'bedside_manner' 1 on the 'recommendation form'
    And I rate 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should be on the 'recommendation' show page
    

  Scenario: Recommend EXISTING Practitioner (new profession)
    Given I goto the 'new recommendation' page
    And a practitioner 'Homer Simpson' exists
    When I modify the 'recommendation form' practitioner_name with 'Homer Simpson'
    And I modify the 'recommendation form' profession_name with 'New type of doctor'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with '6 rue gobert paris france'
    And I rate 'wait_time' 1 on the 'recommendation form'
    And I rate 'availability' 1 on the 'recommendation form'
    And I rate 'bedside_manner' 1 on the 'recommendation form'
    And I rate 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should be on the 'recommendation' show page


  Scenario: Recommend EXISTING Practitioner (bad address)
    Given I goto the 'new recommendation' page
    And a practitioner 'Homer Simpson' exists
    When I modify the 'recommendation form' practitioner_name with 'Homer Simpson'
    And I modify the 'recommendation form' profession_name with 'Doctor'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with 'this is a bad address'
    And I rate 'wait_time' 1 on the 'recommendation form'
    And I rate 'availability' 1 on the 'recommendation form'
    And I rate 'bedside_manner' 1 on the 'recommendation form'
    And I rate 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should see an error message
    And recommendation_form_address should be marked as invalid


  Scenario: Recommend EXISTING Practitioner (blank profession)
    Given I goto the 'new recommendation' page
    And a practitioner 'Homer Simpson' exists
    When I modify the 'recommendation form' practitioner_name with 'Homer Simpson'
    And I modify the 'recommendation form' profession_name with ''
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with 'this is a bad address'
    And I rate 'wait_time' 1 on the 'recommendation form'
    And I rate 'availability' 1 on the 'recommendation form'
    And I rate 'bedside_manner' 1 on the 'recommendation form'
    And I rate 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should see an error message
    And recommendation_form_profession_name should be marked as invalid
