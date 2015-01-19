class Video < ActiveRecord::Base
  belongs_to :artist

  SOME_LIMIT = 4

  TITLE_MAX_LENGTH = 80

  validates_presence_of :title
  validates_length_of :title, :maximum => TITLE_MAX_LENGTH
  validates_presence_of :url
  validates_presence_of :artist_id

  default_scope -> { order( 'created_at desc' ) }
  scope :some, -> { limit( SOME_LIMIT ) }

  def related
    Video.where( artist_id: self.artist_id )
  end
end
