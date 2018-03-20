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