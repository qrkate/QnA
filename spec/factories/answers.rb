FactoryBot.define do
  factory :answer do
    body { "AnswerText" }
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
