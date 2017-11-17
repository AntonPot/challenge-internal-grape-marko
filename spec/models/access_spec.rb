RSpec.describe Access, type: :model do
  it 'has valid factory' do
    expect(build(:access)).to be_valid
  end
  
  it 'has many_to_one relationship with User' do
    expect(build(:access).methods).to include :user
  end
  
  it 'has json without timestamps and user_id' do
    expect(build(:access).as_json).to_not include :created_at, :updated_at, :user_id
  end

  context 'validation' do
    context 'presence' do
      it 'must have a positive integer as level' do
        expect(build(:access, level: nil)).to_not be_valid
        expect(build(:access, level: -1)).to_not be_valid
      end

      it 'must have starts_at of type DateTime' do
        expect(build(:access, starts_at: nil)).to_not be_valid
        expect(build(:access, starts_at: 'hello')).to_not be_valid
        expect(build(:access, starts_at: '123456789')).to_not be_valid
      end
      
      it 'must have ends_at of type DateTime' do
        expect(build(:access, ends_at: nil)).to_not be_valid
        expect(build(:access, ends_at: 'hello')).to_not be_valid
        expect(build(:access, ends_at: '123456789')).to_not be_valid
      end
    end

    context 'time miss-match' do
      it 'ends_at cannot be in the past' do
        expect(build(:access, ends_at: Time.now - 1.minute)).to_not be_valid
      end

      it 'ends_at cannnot be before starts_at' do
        expect(build(:access, starts_at: Time.now + 2.minutes, ends_at: Time.now + 1.minute)).to_not be_valid
      end
    end
  end
end