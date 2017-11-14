require 'app/users'

RSpec.describe Api::Users do
  describe 'GET /user' do
    let(:user) { create(:user) }
    
    context 'positive tests' do
      before do
        set_auth_header(user.token)
        get '/user'
      end

      it 'returns status 200' do
        expect(last_response.status).to be 200
      end

      it 'returns a user' do
        expect(json_response).to include 'user'
      end

      it 'chages access_level' do
        expect(json_response['user']['access_level']).to be 1
      end
    end

    context 'negative tests' do
      context 'returns status 401' do
        before do
          user
        end

        it 'has wrong token' do
          set_auth_header(SecureRandom.uuid.gsub('-', ''))
          get '/user'
          expect(json_response).to include 'error'
          expect(last_response.status).to be 401
        end

        it 'has no token' do
          get '/user'
          expect(json_response).to include 'error'
          expect(last_response.status).to be 401
        end
      end
    end
  end

  describe 'POST /users' do
    it 'creates new user' do      
      expect{ post '/users' }.to change(User, :count).by 1
    end
  end

  describe 'Unknown route' do
    it 'returns status 404' do
      get '/unknown_route_for_testing'
      expect(json_response).to include 'error'
      expect(last_response.status).to be 404
    end
  end
end

