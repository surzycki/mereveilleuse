@acceptance @js
Feature: Registration
  Background: 
    Given the application is setup

  Scenario: Influencer Registration Flow
    Given I goto the 'new registration' page
    When I click 'registration-influencer'
    Then I should see 'Aide une maman'
    And I click 'registration-start'
    And I modify the 'recommendation form' practitioner_name with 'Bob Jones'
    And I modify the 'recommendation form' profession_name with 'Doctor'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with '6 rue gobert paris france'
    Then I click 'registration-rate'
    And I should see 'Poncualité'
    And I rate 'wait_time' 1 on the 'recommendation form'
    Then I should see 'Disponibilité'
    And I rate 'availability' 1 on the 'recommendation form'
    Then I should see 'Ecoute'
    And I rate 'bedside_manner' 1 on the 'recommendation form'
    Then I should see 'Efficacite'
    And I rate 'efficacy' 1 on the 'recommendation form'
    Then I should see 'Personal Experience'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then I should see 'Signature'
    And I click 'registration-sign'