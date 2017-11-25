RSpec.shared_examples_for 'valid' do |model|
  it { expect(build(model)).to be_valid }
end

RSpec.shared_examples_for 'methods are avaliable for' do |model, method|
  it { expect(build(model).methods).to include method }
end