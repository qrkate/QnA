FactoryBot.define do
  factory :award do
    image { Rack::Test::UploadedFile.new('spec/files/award.png') }

    sequence :name do |n|
      "Award #{n}"
    end
  end
end
