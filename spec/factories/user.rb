FactoryBot.define do
  factory :user do
    email                 {"test@gmail.com"}
    name                  {"testuser"}
    password              {"111111"}
    password_confirmation {"111111"}
  end
end