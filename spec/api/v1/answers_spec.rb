require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}

  let(:access_token) {create(:access_token)}
  let(:question) { create(:question) }
  let(:user) { User.find(access_token.resource_owner_id) }
  let!(:answer) { create(:answer, question: question, user: user, files: [fixture_file_upload('spec/spec_helper.rb'), fixture_file_upload('spec/rails_helper.rb')]) }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:comments)  { create_list(:comment, 3, commentable: answer, user: user) }
      let!(:links)     { create_list(:link, 3, linkable: answer) }

      let(:object_response) { json['answer'] }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(object_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it_behaves_like 'API comments'

      it_behaves_like 'API links'

      it_behaves_like 'API files' do
        let(:controller) { answer }
      end
    end
  end

  describe 'POST /api/v1/questoin/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:headers) { nil }
      let(:method)  { :post }
    end

    context 'authorized' do
      context 'with valid params' do
        let(:send_request) { post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token } }

        it 'returns 200 status' do
          send_request
          expect(response).to be_successful
        end

        it 'save new answer' do
          expect { send_request }.to change(Answer, :count).by(1)
        end

        it 'answer has association with user' do
          send_request
          expect(Answer.last.user_id).to eq access_token.resource_owner_id
        end
      end

      context 'with invalid attributes' do
        let(:send_bad_request) { post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token } }

        it 'does not create answer' do
          send_bad_request
          expect(response.status).to eq 422
        end

        it 'does not save answer' do
          expect { send_bad_request }.to_not change(Answer, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:headers) { nil }
      let(:method)  { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) { patch api_path, params: { id: answer, answer: { body: 'Change'}, access_token: access_token.token } }

        it 'returns 200 status' do
          send_request
          expect(response).to be_successful
        end

        it 'assigns the requested answer to @answer' do
          send_request
          expect(assigns(:answer)).to eq answer
        end

        it 'change answer attributes' do
          send_request
          answer.reload

          expect(answer.body).to eq 'Change'
        end
      end

      context 'with invalid attributes' do
        let(:send_bad_request) { patch api_path, params: { id: answer, answer: attributes_for(:answer, :invalid), access_token: access_token.token } }

        it 'returns 422 response status' do
          send_bad_request
          expect(response.status).to eq 422
        end

        it 'does not update answer' do
          body = answer.body
          send_bad_request
          answer.reload

          expect(answer.body).to eq body
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:headers) { nil }
      let(:method)  { :delete }
    end

    context 'authorized' do
      let(:send_request) { delete api_path, params: { id: answer, access_token: access_token.token } }

      it 'returns 200 status' do
        send_request
        expect(response).to be_successful
      end

      it 'delete the answer' do
        expect { send_request }.to change(Answer, :count).by(-1)
      end
    end
  end
end
