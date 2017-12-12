require 'factory_girl'
FactoryBot.define do
  sequence(:enum_field) { |i| :"field#{i}" }
end
