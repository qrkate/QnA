require 'rails_helper'

RSpec.describe QuestionInformJob, type: :job do
  let(:user)     { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer)   { create(:answer, question: question, user: user) }
  let(:service)  { double('QuestionInformService') }

  before do
    allow(QuestionInformService).to receive(:new).and_return(service)
  end

  it 'calls QuestionInformService#new_answer' do
    expect(service).to receive(:send_answer).with(answer)
    QuestionInformJob.perform_now(answer)
  end
end
