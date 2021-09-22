require 'rails_helper'

RSpec.describe QuestionInformService do
  describe '#send_answer' do
    let!(:user) { create(:user) }
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author) }

    let(:answer) { create(:answer, question: question) }

    context 'when there are no other subscribers except owner' do
      it 'sends new answer notification mail to owner of question only' do
        expect(QuestionInformMailer).to receive(:new_answer).with(author, answer).and_call_original
        expect(QuestionInformMailer).not_to receive(:new_answer).with(user, answer)
        subject.send_answer(answer)
      end
    end

    context 'when there are other subscribers' do
      let(:subscribed_users) do
        create_list(:user, 2).tap do |users|
          users.each { |user| create :subscription, question: question, user: user }
        end
      end

      it 'sends new answer notification mail to all subsribed users of question' do
        (subscribed_users + [author]).each do |user|
          expect(QuestionInformMailer).to receive(:new_answer).with(user, answer).and_call_original
        end
        subject.send_answer(answer)
      end
    end
  end
end
