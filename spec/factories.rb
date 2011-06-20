require 'factory_girl'
Factory.sequence(:enum_field) { |i| :"field#{i}" }
