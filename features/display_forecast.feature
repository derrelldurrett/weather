Feature: Get the forecast for a specific location
  We all want to know what the weather is, and what it will be

  Scenario: Enter an address for which to get the forecast
    Given the app is up
    When I go to the root page
    And I enter a legitimate address: "1 Apple Park Way, Cupertino, California"
    Then I receive the observations for the address
    And I receive the forecast for the address

  Scenario: Enter zipcode for which to get the forecast
    Given the app is up
    When I go to the root page
    And I enter a legitimate zipcode: "95014"
    Then I receive the observations for the zipcode
    And I receive the forecast for the zipcode
