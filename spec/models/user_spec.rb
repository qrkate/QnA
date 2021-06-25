require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#is_author?' do
    let(:user) { create(:user) }

    context 'when return true' do
      it 'user is author of resource' do
        expect(user).to be_is_author(create(:question, user: user))
      end
    end

    context 'when return false' do
      it 'user is not author of resource' do
        expect(user).to_not be_is_author(create(:answer))
      end
    end
  end
end
