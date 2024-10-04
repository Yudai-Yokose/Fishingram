FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
