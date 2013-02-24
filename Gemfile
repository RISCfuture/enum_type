source 'https://rubygems.org'

# DEPENDENCIES
gem 'activerecord', '>= 3.0', require: 'active_record'
gem 'activesupport', '>= 3.0', require: 'active_support/core_ext/object/try'

group :development do
  # DEVELOPMENT
  gem 'jeweler'
  gem 'yard'
  gem 'RedCloth', require: 'redcloth'

  # TEST
  gem 'rspec'
  gem 'factory_girl'
  platform(:mri) { gem 'pg' }
  platform(:jruby) { gem 'activerecord-jdbcpostgresql-adapter' }
end
