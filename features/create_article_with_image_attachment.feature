Feature: User can create article with image attachment
  As an Author
  In order be able to add content to the news service
  I would like to be able to publish articles with an image

  Background:
    Given the following users exist:
      | email                 | role    |
      | author@newsroom.com   | author  |
      | random_guy@random.com | visitor |

  Scenario: Author creates an article
    Given I am logged in as "author@newsroom.com"
    Given I am on the create article page
    And I fill in "Title" with "Awesome news"
    And I fill in "Content" with "Lorem ipsum"
    And I attach a file
    And I click "Create Article"
    Then I should be on the article page for "Awesome news"

  Scenario: Visitor tries to create an article
    Given I am logged in as "random_guy@random.com"
    Given I try to visit the create article page
    Then I should be redirected to the index page
    And I should see "You are not authorized to perform that action!"