class Post < ActiveRecord::Base
  belongs_to :artist

  SOME_LIMIT = 4

  TITLE_MAX_LENGTH = 80

  validates :title, presence: true
  validates :title, length: { maximum: TITLE_MAX_LENGTH }
  validates :artist_id, presence: true

  scope :some, -> { limit(SOME_LIMIT) }
  scope :current, -> { where('created_at >= ?', 14.days.ago) }
end
