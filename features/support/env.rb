require 'cucumber/rails'


ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end
Chromedriver.set_version '2.36'

Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
      implicit_wait: 60,
      args: %w( disable-popup-blocking disable-infobars)
  )

  Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: options
  )
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
Cucumber::Rails::Database.javascript_strategy = :truncation

Capybara.default_driver = :selenium

World (FactoryBot::Syntax::Methods)

