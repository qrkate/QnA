require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to(:user).optional(true) }
  it { should belong_to :question}

  it { should have_one_attached(:image) }

  it { should validate_presence_of :name }
  it { should validate_attached_of :image }
  it { should validate_content_type_of(:image).allowing('image/jpeg', 'image/png') }
end
