require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect { post :create, params: { comment: attributes_for(:comment), commentable_type: question.class, commentable_id: question.id, user: user }, format: :js }.to change(question.comments, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { comment: attributes_for(:comment), commentable_type: question.class, commentable_id: question.id, user: user, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { comment: attributes_for(:comment, :invalid), commentable_type: question.class, commentable_id: question.id, user: user }, format: :js }.to_not change(question.comments, :count)
      end

      it 'renders create template' do
        post :create, params: { comment: attributes_for(:comment, :invalid), commentable_type: question.class, commentable_id: question.id, user: user, format: :js }
        expect(response).to render_template :create
      end
    end
  end
end
