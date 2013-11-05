class Post < ActiveRecord::Base
	belongs_to :artist
	has_attached_file :poster, 
		:path => ':rails_root/public/system/:class/:attachment/:id_partition/:style.:extension',
		:url => '/system/:class/:attachment/:id_partition/:style.:extension',
		:styles => { :normal => ["300x400>", :png], :thumb => ["110x110", :png] },
		:default_url => 'missing.png'

  SOME_LIMIT = 4

	TITLE_MAX_LENGTH = 80

	validates :title, :presence => true
	validates :published, :inclusion => { :in => [true, false] }
	validates :title, :length => { :maximum => TITLE_MAX_LENGTH }
	validates :artist_id, :presence => true
  validates :poster_url, :format => /^https?:\/\/.*$/, :allow_nil => true

  default_scope order( 'date(created_at) - current_date DESC' )
	scope :published, where( :published => true )
	scope :unpublished, where( :published => false )
  scope :some, limit( SOME_LIMIT )
  scope :created_in_year, lambda { |y| where( 'extract(year from created_at) = ?', y ) }

	def related
		Post.published.where( artist_id: self.artist_id ).delete_if{ |p| p == self }
	end

  def poster_url=(value)
    value = nil if value.blank?
    super( value )
  end

end

