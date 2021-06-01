require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#is_author?' do
    let(:user) { create(:user) }

    context 'when return true' do
      it 'user is author of resource' do
        question = create(:question, user: user)
        expect(user.is_author?(question)).to be(true)
      end
    end

    context 'when return false' do
      it 'user is not author of resource' do
        question = create(:question)
        expect(user.is_author?(question)).to be(false)
      end
    end
  end
end
