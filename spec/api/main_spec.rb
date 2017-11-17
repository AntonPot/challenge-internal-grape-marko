RSpec.describe Api::Main, type: :request do 
  describe 'Unknown route' do
    it 'returns status 404' do
      get '/unknown_route_for_testing'
      expect(json_response).to include 'error'
      expect(last_response.status).to be 404
    end
  end
end