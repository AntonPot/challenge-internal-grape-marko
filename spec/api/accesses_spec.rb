RSpec.describe Api::Accesses, type: :request do
  let(:access){ create(:access) }
  before { set_auth_header(access.user.token)}

  describe 'GET /accesses' do
    context 'positive tests' do
      context 'returns' do
        before { get '/accesses' }
  
        it '200' do
          expect(last_response.status).to be 200
        end
  
        it 'accesses' do
          expect(json_response).to include :accesses
        end
  
        it 'array of access objects' do
          expect(json_response['accesses'].first['level']).to be 1
        end
      end

      it 'returns array in descending order' do
        access.user.accesses.create( attributes_for(:access, :future))
        get '/accesses'
        test = json_response[:accesses][0][:starts_at] > json_response[:accesses][1][:starts_at]
        expect(test).to be true
      end
    end
    
    context 'negative tests' do
      before do
        set_auth_header(SecureRandom.uuid.gsub('-', ''))
        get '/accesses'
      end
      it_behaves_like 'authenticatable'
    end
  end

    
  describe 'POST /accesses' do
    context 'positive tests' do
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
      context 'authentication' do
        before do
          set_auth_header(SecureRandom.uuid.gsub('-', ''))
          post '/accesses', access: attributes_for(:access)
        end
        it_behaves_like 'authenticatable'
      end

      context 'returns status 422 for parameters of wrong type' do
        it 'level as string' do
          post '/accesses', access: attributes_for(:access).merge(level: 'some string',starts_at: 'some string')
          expect(last_response.status).to be 422
        end

        it 'starts_at as string' do
          post '/accesses', access: attributes_for(:access).merge(starts_at: 'some string')
          expect(last_response.status).to be 422
        end
        
        it 'ends_at as string' do
          post '/accesses', access: attributes_for(:access).merge(ends_at: 'some string')
          expect(last_response.status).to be 422
        end
      end
    end
  end
  

  describe 'DELETE /accesses/:id' do
    context 'positive tests' do
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
      context 'authentication' do
        before do
          set_auth_header(SecureRandom.uuid.gsub('-', ''))
          delete '/accesses/1'
        end
        it_behaves_like 'authenticatable'
      end

      it 'returns 404 for access_id not belonging to current_user' do
        delete "/accesses/#{access.id + 1}"
        expect(last_response.status).to be 404
      end
    end
  end
end
