FactoryBot.define do
  factory :artist do
    email      { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
  end
end
