FactoryBot.define do
  factory :item do
    title       { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    image_url   { 'https://image.com/image.png' }
    artist_id   { 1 }
  end
end
