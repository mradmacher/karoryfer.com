class Post < ActiveRecord::Base
	belongs_to :artist

  SOME_LIMIT = 4

	TITLE_MAX_LENGTH = 80

	validates :title, :presence => true
	validates :published, :inclusion => { :in => [true, false] }
	validates :title, :length => { :maximum => TITLE_MAX_LENGTH }
	validates :artist_id, :presence => true

  default_scope order( 'date(posts.created_at) - current_date DESC' )
	scope :published, where( :published => true )
	scope :unpublished, where( :published => false )
  scope :some, limit( SOME_LIMIT )
  scope :created_in_year, lambda { |y| where( 'extract(year from created_at) = ?', y ) }

	def related
		Post.published.where( artist_id: self.artist_id ).delete_if{ |p| p == self }
	end
end

