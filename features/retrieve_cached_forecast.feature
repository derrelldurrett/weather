Feature: Retrieve a cached version of the observations/forecast if it's not stale
  We all want to know the weather, but it rarely changes so quickly we need to get a
  new observation in less than thirty minutes. We will cache the observation/forecast
  for thirty minutes in order to reduce the load on our servers.

  Scenario: A forecast exists for this zipcode in our database and it's less than thirty minutes old
    Given the app is up
    And the time is less than thirty minutes after my most recent call
    And a cached forecast exists for my zipcode
    When I go to the root page
    And I enter a legitimate zipcode: "95014"
    Then I receive the cached observations for the zipcode
