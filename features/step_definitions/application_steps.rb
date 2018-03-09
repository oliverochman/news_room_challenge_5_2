Given(/^I am on the create article page$/) do
  visit new_article_path
end

Then(/^I should see "([^"]*)"$/) do |content|
  expect(page).to have_content content
end

And(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  sleep 1
  fill_in field, with: value
end


And(/^I attach a file$/) do
  attach_file('article_image', "#{::Rails.root}/spec/fixtures/dummy_image.jpg")
end

And(/^I click "([^"]*)"$/) do |value|
  click_link_or_button value
end