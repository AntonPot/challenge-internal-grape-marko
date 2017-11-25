RSpec.shared_examples_for 'authenticatable' do
  it 'returns 401 if token is wrong' do
    expect(json_response).to include 'error'
    expect(last_response.status).to be 401
  end
end