require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:question) { create(:question, files: [fixture_file_upload('spec/spec_helper.rb')]) }

    context 'sign in as record author' do
      before { login(question.user) }

      it 'deletes file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'sign in as not record author' do
      before { login(create(:user)) }

      it 'not deletes file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
