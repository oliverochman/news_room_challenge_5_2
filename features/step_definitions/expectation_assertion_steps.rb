Then(/^I should be on the article page for "([^"]*)"$/) do |article_title|
  article = Article.find_by(title: article_title)
  expect(current_path).to eq article_path(article)
end

Then(/^I should be redirected to the index page$/) do
  expect(current_path).to eq root_path
end

And(/^I should see "([^"]*)"$/) do |expected_content|
  expect(page).to have_content expected_content
end

Then(/^the center of the map should be approximately "([^"]*)" lat and "([^"]*)" lng$/) do |lat, lng|
  ACCEPTED_OFFSET = 0.2
  center_lat = page.evaluate_script('map.getCenter().lat();')
  center_lng = page.evaluate_script('map.getCenter().lng();')
  expect(center_lat).to be_within(ACCEPTED_OFFSET).of(lat.to_f)
  expect(center_lng).to be_within(ACCEPTED_OFFSET).of(lng.to_f)
end