FactoryBot.define do
  factory :event do
    name { Faker::Lorem.characters(number: 10) }
    introduction { Faker::Lorem.characters(number: 20) }
    genre_id { 1 }
    start_at { "2021-11-01 00:00:00" }
    finish_at { "2021-11-01 12:00:00" }
    deadline { "2021-10-31 00:00:00" }
    capacity { 3 }
    tool { "ZOOM" }
    is_valid { true }
    admin_user_id { 1 }
  end
end
