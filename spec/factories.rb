require 'factory_girl'
FactoryGirl.define do
  sequence(:enum_field) { |i| :"field#{i}" }
end
