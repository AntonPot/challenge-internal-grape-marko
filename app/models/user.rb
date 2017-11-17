class User < ActiveRecord::Base
  before_create :set_token    
  has_many :accesses

  def as_json
    super(root: true, except: [:created_at, :updated_at])
  end
  
  private

  def set_token
    self.token = generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.uuid.gsub('-', '')
      break token unless User.where(token: token).exists?
    end
  end
end
