require 'app/accesses'

RSpec.describe Api::Accesses do
  let(:access){ create(:access) }

  describe 'GET /accesses' do
    before { access }
      
    context 'positive tests' do
      before { set_auth_header(access.user.token) }
      it 'returns 200' do
        get '/accesses'
        expect(last_response.status).to be 200
      end

      it 'returns array of access objects' do
        get '/accesses'
        expect(json_response.count).to be 1
      end
    end
    
    context 'negative tests' do
      context 'returns status 401 for authentication failure' do
        it 'wrong token' do
          set_auth_header(SecureRandom.uuid.gsub('-', ''))
          get '/accesses'
          expect(json_response).to include 'error'
          expect(last_response.status).to be 401
        end

        it 'no token' do
          get '/accesses'
          expect(json_response).to include 'error'
          expect(last_response.status).to be 401
        end
      end
    end
  end

    
  describe 'POST /accesses' do
    context 'positive tests' do
      before { set_auth_header(access.user.token) }
      it 'creates a new access object' do 
        expect {
          post '/accesses', access: attributes_for(:access)
        }.to change(Access, :count).by 1
      end

      it 'returns created access object' do
        post '/accesses', access: attributes_for(:access)
        expect(json_response).to include 'access'
      end
    end

    context 'negative tests' do
      context 'returns status 400 for parameters of wrong type' do
        it 'level as string' do
          post '/accesses', access: attributes_for(:access).merge(level: 'string')
          expect(last_response.status).to be 400
        end

        it 'starts_at as string' do
          post '/accesses', access: attributes_for(:access).merge(starts_at: 'some string')
          expect(last_response.status).to be 400
        end
        
        it 'ends_at as string' do
          post '/accesses', access: attributes_for(:access).merge(ends_at: 'some string')
          expect(last_response.status).to be 400
        end
      end
      
      context 'returns status 401 for authentication failure' do
        it 'wrong token' do
          set_auth_header(SecureRandom.uuid.gsub('-', ''))
          post '/accesses', access: attributes_for(:access)
          expect(json_response).to include 'error'
          expect(last_response.status).to be 401
        end

        it 'no token' do
          post '/accesses', access: attributes_for(:access)
          expect(json_response).to include 'error'
          expect(last_response.status).to be 401
        end
      end
    end
  end
  

  describe 'DELETE /accesses/:id' do
    context 'positive tests' do
      before { set_auth_header(access.user.token) }
      it 'returns 204' do
        delete "/accesses/#{access.id}"
        expect(last_response.status).to be 204
      end
      
      it 'destroys an access object' do
        expect {
          delete "/accesses/#{access.id}"
        }.to change(Access, :count).by(-1)
      end
    end

    context 'negative tests' do
      it 'returns 422 for access_id not belonging to current_user' do
        set_auth_header(access.user.token)
        delete "/accesses/#{access.id + 1}"
        expect(last_response.status).to be 422
      end

      context 'returns status 401 for authentication failure' do
        it 'wrong token' do
          access
          set_auth_header(SecureRandom.uuid.gsub('-', ''))
          delete '/accesses/1'
          expect(json_response).to include 'error'
          expect(last_response.status).to be 401
        end

        it 'no token' do
          access
          delete '/accesses/1'
          expect(json_response).to include 'error'
          expect(last_response.status).to be 401
        end
      end
    end
  end
end
