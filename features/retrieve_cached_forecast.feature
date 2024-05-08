Feature: Retrieve a cached version of the observations/forecast if it's not stale
  We all want to know the weather, but it rarely changes so quickly we need to get a
  new observation in less than thirty minutes. We will cache the observation/forecast
  for thirty minutes in order to reduce the load on our servers.

  @cached
  Scenario: A forecast exists for this zipcode in our database and it's less than thirty minutes old
    Given the app is up
    And a cached forecast exists for my zipcode
    And the time is now a time when I would expect a cached observation
    When I go to the root page
    And I enter a legitimate zipcode: "95014"
    Then I receive the cached observations for the zipcode
    And I receive the cached forecast for the zipcode

  @refreshed
  Scenario: A forecast exists for this zipcode in our database but it's more than thirty minutes old
    Given the app is up
    And a cached forecast exists for my zipcode
    And the time is now a time when I would expect a refreshed observation
    When I go to the root page
    And I enter a legitimate zipcode: "95014"
    Then I receive the refreshed observations for the zipcode
    And I receive the refreshed forecast for the zipcode
