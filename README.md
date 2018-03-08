# News Room Challenge
Using Rails 5.2 with Active Storage

## New app using Rails 5.2.0 (RC1)

```
$ rvm gemset create rails_5_2
$ rvm gemset use rails_5_2
$ gem install rails --pre
$ rails new news_room --database:postgresql --skip-test --skip-bundle
$ cd news_room
```

```
$ touch .ruby-gemset
```
Set gemset to use. This will automatically switch to the right gemset when you cd into the project folder.
```
rails_5_2
```

### HAML?
Ifo you want to use HAML as templating (as I will do) add `haml-rails` to your `Gemfile`. 


### Frameworks and tools

```
group :development, :test do
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end
```

### Configuration

```
module NewsRoom
  class Application < Rails::Application
    config.load_defaults 5.2
    config.generators do |generate|
      generate.helper false
      generate.assets false
      generate.view_specs false
      generate.helper_specs false
      generate.routing_specs false
      generate.controller_specs false
      generate.system_tests false
    end
  end
end
```

Open spec/rails_helper.rb and add the following block at the end of the file.

```
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails 
  end
end
```

Add Acceptance test framework

```
group :development, :test do
  # Add Cucumber and Database Cleaner
  gem 'cucumber-rails', '~> 1.4', '>= 1.4.5', require: false
  gem 'database_cleaner'
end
```

Configure testing frameworks with default settings
```
$ bundle exec rails generate cucumber:install
$ bundle exec rails generate rspec:install
```

```
$ rails db:create db:migrate
```

Run your tests to check if all setup is working:

```
$ rake
```
If all is good, commit and push.

### Active Storage
Working on a separate branch (not `master`)

Active Storage comes with some custom migrations (investigate why)

Copy the migrations to your `db/migrations` folder:

```
$ rails active_storage:install:migrations
```

### Create `Article` model
```
$ rails g model article title:string body:text

      invoke  active_record
      create    db/migrate/20180308211352_create_articles.rb
      create    app/models/article.rb
      invoke    rspec
      create      spec/models/article_spec.rb
      invoke      factory_bot
      create        spec/factories/articles.rb
```

Let's start with adding an image to the Article model 

```
class Article < ApplicationRecord
  has_one_attached :image
end
```
We don't have to create an `Image`  model. Active Storage uses the Blob and Attachment under the hood to give us `article.image`.

### ArticlesController
```
$  rails g controller Articles new show
create  app/controllers/articles_controller.rb
       route  get 'articles/new'
get 'articles/show'
      invoke  haml
      create    app/views/articles
      create    app/views/articles/new.html.haml
      create    app/views/articles/show.html.haml
      invoke  rspec
```

I always modify my routes to use the `resources` keyword:

```
Rails.application.routes.draw do
  resources :articles, only: [:new, :create, :show]
end
```

### Routes
With this setup, our routes table looks something like this:
```
$ rails routes
                   Prefix Verb URI Pattern                                                                       Controller#Action
                 articles POST /articles(.:format)                                                               articles#create
              new_article GET  /articles/new(.:format)                                                           articles#new
                  article GET  /articles/:id(.:format)                                                           articles#show
       rails_service_blob GET  /rails/active_storage/blobs/:signed_id/*filename(.:format)                        active_storage/blobs#show
     rails_blob_variation GET  /rails/active_storage/variants/:signed_blob_id/:variation_key/*filename(.:format) active_storage/variants#show
       rails_blob_preview GET  /rails/active_storage/previews/:signed_blob_id/:variation_key/*filename(.:format) active_storage/previews#show
       rails_disk_service GET  /rails/active_storage/disk/:encoded_key/*filename(.:format)                       active_storage/disk#show
update_rails_disk_service PUT  /rails/active_storage/disk/:encoded_token(.:format)                               active_storage/disk#update
     rails_direct_uploads POST /rails/active_storage/direct_uploads(.:format)                                    active_storage/direct_uploads#create
```
