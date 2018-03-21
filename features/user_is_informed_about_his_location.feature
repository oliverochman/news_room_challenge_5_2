Feature: User is informed about his location
  As a visitor
  In order to get localized news
  I would like the application to know where I am

  Scenario: User is in Goteborg
    Given I am at latitude: "59.334591", longitude: "18.063240"
    And I visit the site
    Then I should see "West Coast Edition"