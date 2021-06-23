require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { create(:question) }
  let!(:answer1) { create(:answer, question: question) }
  let!(:answer2) { create(:answer, question: question) }

  it { should belong_to :user }
  it { should belong_to :question }

  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  describe '.default_scope' do
    before { answer2.best! }

    it 'should sort answers by best' do
      expect(question.answers.all).to eq [answer2, answer1]
    end
  end

  describe '#best!' do
    before { answer1.best! }

    it 'makes answer the best' do
      expect(answer1).to be_best
    end

    it 'change the best answer' do
      answer2.best!
      answer1.reload

      expect(answer1).to_not be_best
      expect(answer2).to be_best
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
