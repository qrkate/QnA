FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '123345678' }
    password_confirmation { '123345678' }
  end
end
