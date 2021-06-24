FactoryBot.define do
  factory :link do
    name { "Netflix" }
    url { "netflix.com" }
    linkable { create(:question) }
  end
end
