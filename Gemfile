source 'http://rubygems.org'

ruby '1.9.3'

gem 'rake'
gem 'rails', '~> 3.2'

group :assets do
  gem 'sass-rails'
  gem 'therubyracer'
  gem 'uglifier'
  gem 'handlebars_assets'
end

gem 'jquery-rails'

gem "bundler"
gem 'unicorn'
gem "auto_tagger"
gem "json"
gem "pg"
gem "haml"
gem "haml-rails"
gem "paperclip"
gem 'rmagick'
gem 'heroku'
gem 'newrelic_rpm'
gem 'aws-s3'
gem 'aws-sdk'
gem 'mail'
gem 'devise'
gem 'omniauth-openid'
gem 'aws-ses', require: 'aws/ses'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'jasmine', '~> 2.0.0.rc5'
  gem "headless"

  gem 'jshint_on_rails'
  gem 'shoulda'
  gem 'factory_girl_rails'
  gem 'fixture_builder'
end

group :development do
  gem "heroku_san", "1.3.0"
  gem "hpricot"
  gem "ruby_parser"
  gem "foreman"
end
