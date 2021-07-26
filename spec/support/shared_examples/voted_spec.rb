shared_examples "voted" do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }
  let(:votable) { create(model.to_s.underscore.to_sym, user: author) }
  let(:expected_response) { { id: votable.id, type: votable.class.to_s.downcase, rating: votable.rating }.to_json }
  let(:error_response) { { message: "You can't vote!" }.to_json }

  describe 'PATCH #vote_for' do
    let(:http_request) { patch :vote_for, params: { id: votable, format: :json } }

    context 'for not votable user' do
      before { login(user) }

      it 'saves a new vote' do
        expect { http_request }.to change(Vote, :count).by(1)
      end

      it 'render valid json' do
        http_request
        expect(response.body).to eq expected_response
      end
    end

    context 'for votable user' do
      before { login(user) }
      before { patch :vote_for, params: { id: votable } }

      it 'not saves a new vote' do
        expect { http_request }.to_not change(Vote, :count)
      end
    end

    context 'for user-author' do
      before { login(author) }

      it 'not saves a new vote' do
        expect { http_request }.to_not change(Vote, :count)
      end

      it 'returns the error response' do
        http_request
        expect(response.body).to eq error_response
      end
    end

    context 'for unauthorized user' do
      it 'not saves a new vote' do
        expect { http_request }.to_not change(Vote, :count)
      end

      it 'returns 401' do
        http_request
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'PATCH #vote_against' do
    let(:http_request) { patch :vote_against, params: { id: votable, format: :json } }

    context 'for not votable user' do
      before { login(user) }

      it 'saves a new vote' do
        expect { http_request }.to change(votable, :rating).by(-1)
      end

      it 'render valid json' do
        http_request
        expect(response.body).to eq expected_response
      end
    end

    context 'for votable user' do
      before { login(user) }
      before { patch :vote_against, params: { id: votable } }

      it 'not saves a new vote' do
        expect { http_request }.to_not change(Vote, :count)
      end
    end

    context 'for user-author' do
      before { login(author) }

      it 'not saves a new vote' do
        expect { http_request }.to_not change(Vote, :count)
      end

      it 'returns the error response' do
        http_request
        expect(response.body).to eq error_response
      end
    end

    context 'for unauthorized user' do
      it 'not saves a new vote' do
        expect { http_request }.to_not change(Vote, :count)
      end

      it 'returns 401' do
        http_request
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'PATCH #nullify' do
    let(:http_request) { patch :nullify, params: { id: votable, format: :json } }

    context 'for not votable user' do
      before { login(user) }

      it 'not saves a new vote' do
        expect { http_request }.to_not change(Vote, :count)
      end

      it 'render valid json' do
        http_request
        expect(response.body).to eq expected_response
      end
    end

    context 'for votable user' do
      before { login(user) }
      before { patch :vote_for, params: { id: votable } }

      it 'nullify vote' do
        expect { http_request }.to change(votable, :rating).by(-1)
      end
    end

    context 'for user-author' do
      before { login(author) }

      it 'not saves a new vote' do
        expect { http_request }.to_not change(Vote, :count)
      end

      it 'returns the error response' do
        http_request
        expect(response.body).to eq error_response
      end
    end

    context 'for unauthorized user' do
      it 'not saves a new vote' do
        expect { http_request }.to_not change(Vote, :count)
      end

      it 'returns 401' do
        http_request
        expect(response).to be_unauthorized
      end
    end
  end
end
