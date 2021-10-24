FactoryBot.define do
  factory :group_new do
    group_id { 1 }
    title { Faker::Lorem.characters(number: 10) }
    body { Faker::Lorem.characters(number: 20) }
  end
end