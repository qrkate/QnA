require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  describe 'GET #index' do
    let(:question) { create(:question) }
    let!(:award) { create(:award, question: question, user: question.user) }

    before do
      login(question.user)
      get :index
    end

    it 'assigns awards equal to user awards' do
      expect(assigns(:awards)).to eq question.user.awards
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
