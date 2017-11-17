require_relative '../app/models/user.rb'
require_relative '../app/models/access.rb'

5.times do
  user = User.create
  5.times do |i|
    user.accesses.create(
      level: i, 
      starts_at: Time.now + i, 
      ends_at: Time.now + i)
  end
end
