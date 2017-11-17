RSpec.describe User, type: :model do 
  it 'has valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'has access_level 0' do
    expect(build(:user).access_level).to be 0
  end
  
  it 'has a 32 character token' do
    expect(create(:user).token.size).to be 32
  end

  it 'has one_to_many relation with Access' do
    expect(build(:user).methods).to include :accesses
  end

  it 'has json with root and without timestamps' do
    json_hash = build(:user).as_json
    expect(json_hash).to include 'user'
    expect(json_hash['user']).to_not include :created_at, :updated_at
  end
end