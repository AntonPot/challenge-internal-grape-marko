RSpec.describe Api::Users, type: :request do
  describe 'GET /user' do
    let!(:user)  { create(:user)}    

    context 'positive tests' do
      let!(:set_headers) { set_auth_header(user.token) }
      
      context 'response' do
        before { get '/user' }

        it 'returns status 200' do
          expect(last_response.status).to be 200
        end

        it 'returns a user JSON' do
          expect(json_response).to eql(
            'user' => {
              'id' => user.id,
              'token' => user.token,
              'access_level' => user.access_level
            })
        end
      end

      it 'changes access level' do
        user.accesses.create(attributes_for(:access, level: 2))
        get '/user'
        expect(json_response[:user][:access_level]).to be 2
      end
    end

    context 'negative tests' do
      before do
        set_auth_header(SecureRandom.uuid.gsub('-', ''))
        get '/user'
      end
      it_behaves_like 'authenticatable'
    end
  end

  describe 'POST /users' do
    it 'creates new user' do      
      expect{ post '/users' }.to change(User, :count).by 1
    end
  end
end

