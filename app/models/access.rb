class Access < ActiveRecord::Base
  belongs_to :user
  validates :level, :starts_at, :ends_at, presence: true
  validates :level, numericality: { greater_than_or_equal_to: 0 }
  validate :ends_at_cannot_be_in_the_past
  validate :ends_at_cannot_be_before_starts_at

  def as_json(options = {})
    default_options = {except: [:created_at, :updated_at, :user_id]}
    super(default_options.merge(options))
  end

  private
  
  def ends_at_cannot_be_in_the_past
    if ends_at.present? && ends_at < (Time.now )
      errors.add(:ends_at, "cannot be in the past")
    end
  end

  def ends_at_cannot_be_before_starts_at
    if starts_at.present? && ends_at.present? && starts_at > ends_at
      errors.add(:ends_at, "cannot finish before it begins")
    end
  end
end
