RSpec.describe Accessibilty do
  let!(:user) { create(:user) }
  before { set_auth_header(user) }
  
  it 'ignores future accesses' do
    user.accesses.create(attributes_for(:access, :future))          
    expect(Accessibilty.check_for(user)).to be nil
  end

  it 'returns highest access level' do
    [3,5,1,2,4].each { |l| user.accesses.create(attributes_for(:access).merge({level: l}))}
    expect(Accessibilty.check_for(user).level).to be 5
  end
end