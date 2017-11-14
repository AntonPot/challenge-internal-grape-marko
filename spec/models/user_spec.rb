RSpec.describe User, type: :model do 
  context 'positive tests' do
    it 'has valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'has access_level 0' do
      expect(build(:user).access_level).to be 0
    end
    
    it 'has a 32 character token' do
      expect(create(:user).token.size).to be 32
    end
  end
end