module Accessibilty
  # Find user accesses that are currently active and get the one with highest level
  def self.check_for(user)
    user.accesses.where(
      "starts_at < ? AND ends_at > ? OR ends_at IS ?", Time.now, Time.now, nil
    ).order(:level).last
  end
end