Then(/^I should be on the article page for "([^"]*)"$/) do |article_title|
  article = Article.find_by(title: article_title)
  expect(current_path).to eq article_path(article)
end