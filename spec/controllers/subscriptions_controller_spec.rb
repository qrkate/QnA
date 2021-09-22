require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }

    context 'when authenticated user' do
      let(:user) { create(:user) }

      before { login(user) }

      it 'creates new subscription for question' do
        expect { post :create, params: { question_id: question }, format: :js }.to change { question.subscriptions.count }.by(1)
      end

      it 'creates new subscription for user' do
        expect { post :create, params: { question_id: question }, format: :js }.to change { user.subscriptions.count }.by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question }, format: :js
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'when unauthenticated user' do
      it 'does not create new subscription' do
        expect { post :create, params: { question_id: question }, format: :js }.not_to change(Subscription, :count)
      end

      it 'returns unauthorized status' do
        post :create, params: { question_id: question }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    context 'when authenticated user' do
      let(:user) { create(:user) }

      before { login(user) }
      before { question.subscriptions.create!(user: user) }

      it 'unsubscribe from question' do
        expect { delete :destroy, params: { question_id: question }, format: :js }.to change(question.subscriptions, :count).by(-1)
      end

      it 'destroys the subscription for user' do
        expect { delete :destroy, params: { question_id: question }, format: :js }.to change(question.subscriptions, :count).by(-1)
      end

      it 'returns unauthorized status' do
        delete :destroy, params: { question_id: question }, format: :js
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'when unauthenticated user' do
      it 'does not create new subscription' do
        expect { delete :destroy, params: { question_id: question }, format: :js }.not_to change(Subscription, :count)
      end

      it 'returns unauthorized status' do
        delete :destroy, params: { question_id: question }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
