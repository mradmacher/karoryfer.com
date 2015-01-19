class Post < ActiveRecord::Base
  belongs_to :artist

  SOME_LIMIT = 4

  TITLE_MAX_LENGTH = 80

  validates :title, :presence => true
  validates :title, :length => { :maximum => TITLE_MAX_LENGTH }
  validates :artist_id, :presence => true

  default_scope -> { order( 'date(posts.created_at) - current_date DESC' ) }
  scope :some, -> { limit( SOME_LIMIT ) }
  scope :created_in_year, -> (y) { where( 'extract(year from created_at) = ?', y ) }
end

