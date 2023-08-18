source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 7.0.7"

gem "bootsnap", require: false
gem "devise"
gem "govuk_app_config"
gem "jbuilder"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development do
  gem "web-console"
end

group :test do
  gem "simplecov"
end

group :development, :test do
  gem "govuk_test"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "rubocop-govuk"
end
