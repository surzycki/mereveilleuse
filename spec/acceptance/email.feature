@acceptance 
Feature: Emails
  @wip
  Scenario: Recommendation Email Goto Recommendation Page
    Given a recommendation email was sent
    When I click 'new-recomendation' in the email
    Then I should be on the 'new recommendation' page

  @wip
  Scenario: Recommendation Email Unsubscribe Search
    Given a recommendation email was sent
    When I click 'unsubscribe-search' in the email
    Then I should be on the 'unsubscribe search' page for the 'search'

  @wip
  Scenario: Recommendation Email Unsubscribe Account
    Given a recommendation email was sent
    When I click 'unsubscribe-account' in the email
    Then I should be on the 'unsubscribe account' page for the 'user'

