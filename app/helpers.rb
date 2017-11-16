module JSONFormatter
  def self.for_user(user)
    {
      user: {
        id: user.id,
        token: user.token,
        access_level: user.access_level
      }
    }
  end

  def self.for_accesses(accesses)
    { 
      accesses: accesses.map{ |access| for_access(access)}
    }
  end

  def self.for_access(access)
    { 
      id: access.id,
      level: access.level,
      starts_at: access.starts_at,
      ends_at: access.ends_at
    }
  end
end