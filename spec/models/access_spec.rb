RSpec.describe Access, type: :model do
  context 'positive tests' do
    it 'has valid factory' do
      expect(build(:access)).to be_valid
    end
    
    it 'belongs to User' do
      expect(create(:access).user_id.class).to be Integer
    end
  end

  context 'negative tests' do
    context 'validation' do
      context 'presence' do
        it 'must have a positive integer as level' do
          expect(build(:access, level: nil)).to_not be_valid
          expect(build(:access, level: -1)).to_not be_valid
        end

        it 'must have a starts_at date' do
          expect(build(:access, starts_at: nil)).to_not be_valid
        end

        it 'must have an ends_at date' do
          expect(build(:access, ends_at: nil)).to_not be_valid
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
end