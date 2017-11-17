module Accessibilty
  # Find user accesses that are currently active and get the one with highest level
  def self.check_for(user)
    user.accesses.order(:level).map { |access|
      access if (access.starts_at < Time.now) && (Time.now < access.ends_at)
    }.last 
  end
end