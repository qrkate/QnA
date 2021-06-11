require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }

  it { should validate_presence_of :body }

  describe '.default_scope' do
    let(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question) }
    before { answer2.best! }

    it 'should sort answers by best' do
      expect(question.answers.all).to eq [answer2, answer1]
    end
  end

  describe '#best!' do
    let(:answer) { create(:answer) }
    it 'makes answer the best' do
      answer.best!

      expect(answer).to be_best
    end
  end
end
