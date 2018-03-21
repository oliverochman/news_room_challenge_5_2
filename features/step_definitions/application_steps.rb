Given(/^I (?:am on|try to visit) the create article page$/) do
  visit new_article_path
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

Given(/^the following users exist:$/) do |table|
  table.hashes.each do |user_hash|
    create(:user, user_hash)
  end
end

Given(/^I am logged in as "([^"]*)"$/) do |email|
  user = User.find_by(email: email)
  login_as(user, scope: :user)
end

And(/^I visit the site$/) do
  visit root_path
end

Given(/^I am at latitude: "([^"]*)", longitude: "([^"]*)"$/) do |lat, lng|
  Rails.application.config.fake_location = { latitude: lat, longitude: lng }
end

