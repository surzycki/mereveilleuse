@acceptance @js @wip
Feature: Marketing Pixels
  Background: 
    Given the application is setup
    And I am logged in
    
  Scenario: Completed Recommendation
    Given I goto the 'new recommendation' page
    When I modify the 'recommendation form' practitioner_name with 'Bob Jojo'
    And I modify the 'recommendation form' profession_name with 'Doctor'
    And I select 'Person' from patient_type_id on 'recommendation form' 
    And I modify the 'recommendation form' address with '6 rue gobert paris france'
    And I rate 'wait_time' 1 on the 'recommendation form'
    And I rate 'availability' 1 on the 'recommendation form'
    And I rate 'bedside_manner' 1 on the 'recommendation form'
    And I rate 'efficacy' 1 on the 'recommendation form'
    And I modify the 'recommendation form' comment with 'It is great'
    And I submit the form
    Then the Facebook 'Mereveilleuse - Registration' conversion pixel should be fired
    And the Facebook 'Mereveilleuse - Landing' conversion pixel should not be fired

  Scenario: New Recommendation
    Given I goto the 'new recommendation' page
    Then the Facebook 'Mereveilleuse - Registration' conversion pixel should not be fired
    And the Facebook 'Mereveilleuse - Landing' conversion pixel should not be fired

  Scenario: New Search 
    Given I goto the 'new search' page
    Then the Facebook 'Mereveilleuse - Registration' conversion pixel should not be fired
    And the Facebook 'Mereveilleuse - Landing' conversion pixel should not be fired

  Scenario: New Registration 
    Given I goto the 'new registration' page
    Then the Facebook 'Mereveilleuse - Registration' conversion pixel should not be fired
    And the Facebook 'Mereveilleuse - Landing' conversion pixel should be fired
    
