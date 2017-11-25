RSpec.describe User, type: :model do 
  let(:user) { build(:user) }
  
  it_behaves_like 'valid', :user
  it_behaves_like 'methods are avaliable for', :user, :accesses

  it { expect(user.access_level).to be 0 }
  it { expect(create(:user).token.size).to be 32 }
  
  it 'has json with root and without timestamps' do
    json_hash = build(:user).as_json
    expect(json_hash).to include 'user'
    expect(json_hash['user']).to_not include :created_at, :updated_at
  end
end