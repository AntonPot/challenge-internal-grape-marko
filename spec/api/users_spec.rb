require 'app/users'

RSpec.describe Api::Users do
  describe 'GET /user' do
    let!(:user)  { create(:user)}    

    context 'positive tests' do
      let!(:set_headers) { set_auth_header(user.token) }
      
      context 'response' do
        before do
          get '/user'
        end

        it 'returns status 200' do
          expect(last_response.status).to be 200
        end

        it 'returns a user' do
          expect(json_response).to include 'user'
        end
      end

      context 'access_level' do
        it 'ignores future accesses' do
          user.accesses.create(attributes_for(:access, :future))          
          get '/user'
          expect(json_response['user']['access_level']).to be 0
        end
  
        it 'sets highest access level' do
          [3,5,1,2,4].each { |l| user.accesses.create(attributes_for(:access).merge({level: l}))}
          get '/user'
          expect(json_response[:user][:access_level]).to be 5
        end
      end
    end

    context 'negative tests' do
      context 'returns status 401' do
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
end

