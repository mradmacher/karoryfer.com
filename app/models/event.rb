class Event < ActiveRecord::Base
	belongs_to :artist

  SOME_LIMIT = 4
	TITLE_MAX_LENGTH = 80

	validates :title, :presence => true
	validates :published, :inclusion => { :in => [true, false] }
	validates :title, :length => { :maximum => TITLE_MAX_LENGTH }
	validates :artist_id, :presence => true
  validates :event_date, :presence => true
	validates :free_entrance, :inclusion => { :in => [true, false] }

  default_scope order( '(CASE WHEN event_date - current_date >= 0 THEN 1 ELSE 0 END) DESC, abs(event_date - current_date) ASC' )

	scope :published, where( :published => true )
	scope :unpublished, where( :published => false )
  scope :current, where( 'event_date - current_date >= 0' )
  scope :some, limit( SOME_LIMIT )
  scope :for_day, lambda { |y, m, d| where( 'extract(day from event_date) = ? and extract(month from event_date) = ? and extract(year from event_date) = ?', d, m, y ) }
  scope :for_month, lambda { |y, m| where( 'extract(month from event_date) = ? and extract(year from event_date) = ?', m, y ) }
  scope :for_year, lambda { |y| where( 'extract(year from event_date) = ?', y ) }

  mount_uploader :poster, Uploader::EventImage

	def related
		Event.published.where( artist_id: self.artist_id ).delete_if{ |p| p == self }
	end

  def expired?
    return false if self.event_date.nil?
    last_date = self.event_date + self.duration.days
    !(last_date.today? || last_date.future?)
  end

  def recognized_external_urls
    result = {}
    URI.extract(external_urls || '', ['http', 'https']).map{ |url| result[url] = URI.parse(url).host }
    result
  end
end
