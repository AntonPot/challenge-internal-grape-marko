RSpec.describe Access, type: :model do
  let(:access) { build(:access) }

  it_behaves_like 'valid', :access
  it_behaves_like 'methods are avaliable for', :access, :user

  it { expect(access.as_json).to_not include :created_at, :updated_at, :user_id }

  context 'validation' do
    context 'presence' do
      it 'must have a positive integer as level' do
        expect(build(:access, level: nil)).to_not be_valid
        expect(build(:access, level: -1)).to_not be_valid
      end

      it 'must have starts_at of type Time' do
        expect(build(:access, starts_at: nil)).to_not be_valid
        expect(build(:access, starts_at: 'hello')).to_not be_valid
        expect(build(:access, starts_at: '123456789')).to_not be_valid
      end
      
      it 'allows ends_at to be nil' do
        expect(build(:access, ends_at: nil)).to be_valid
        expect(build(:access, ends_at: 'hello')).to be_valid
        expect(build(:access, ends_at: '123456789').ends_at).to be nil
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