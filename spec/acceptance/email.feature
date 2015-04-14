@acceptance 
Feature: Emails
  @wip
  Scenario: Recommendation Email Goto Recommendation Page
    Given a recommendation email was sent
    When I click 'new-recomendation' in the email
    Then I should be on the 'new recommendation' page


  Scenario: Recommendation Email Unsubscribe Search
    Given a recommendation email was sent
    When I click 'unsubscribe-search' in the email
    Then I should be on search unsubscribe location

  
  Scenario: Recommendation Email Unsubscribe Account
    Given a recommendation email was sent
    When I click 'unsubscribe-account' in the email
    Then I should be on the 'unsubscribe account' page for the 'user' identified by 'login_token'

