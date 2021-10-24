FactoryBot.define do
  factory :contact do
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    title { Faker::Lorem.characters(number: 10) }
    body { Faker::Lorem.characters(number: 30) }
  end
end
