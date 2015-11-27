class Video < ActiveRecord::Base
  belongs_to :artist

  SOME_LIMIT = 4

  TITLE_MAX_LENGTH = 80

  validates :title, presence: true
  validates :title, length: { maximum: TITLE_MAX_LENGTH }
  validates :url, presence: true
  validates :artist_id, presence: true

  default_scope -> { order('created_at desc') }
  scope :some, -> { limit(SOME_LIMIT) }

  def related
    Video.where(artist_id: self.artist_id)
  end
end
