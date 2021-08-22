require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let!(:comments) { create_list(:comment, 2, commentable: question, user: question.user) }
  let!(:comment2) { create(:comment, commentable: answer, user: question.user) }

  it { should belong_to :commentable }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  context '.default_scope' do
    it 'should sort comments by created_at' do
      expect(question.comments.all).to eq [comments[0], comments[1]]
    end
  end

  describe '#find_question' do
    context "when question's comment" do
      it "should find question" do
        result = comments[0].find_question
        expect(result).to eq question
      end
    end

    context "when answer's comment" do
      it "should find question" do
        result = comment2.find_question
        expect(result).to eq question
      end
    end
  end
end
