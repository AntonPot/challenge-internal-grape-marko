RSpec.describe Accessibilty do
  let!(:user) {
    user = create(:user)
    user.accesses << create(:access)
    user.accesses << create(:access, ends_at: nil)
    user.accesses << create(:access, :future)
    set_auth_header(user)
    user
  }

  it { expect(Accessibilty.check_for(user)).to be_an Access }
  
  it 'ignores future accesses' do
    expect(Accessibilty.check_for(user).level).to be 1
  end

  it 'returns highest access level' do
    [3,5,1,2,4].each { |l| user.accesses.create(attributes_for(:access).merge({level: l}))}
    expect(Accessibilty.check_for(user).level).to be 5
  end
end