class Event < ActiveRecord::Base
  belongs_to :artist

  SOME_LIMIT = 4
  TITLE_MAX_LENGTH = 80

  validates :title, presence: true
  validates :title, length: { maximum: TITLE_MAX_LENGTH }
  validates :artist_id, presence: true
  validates :event_date, presence: true
  validates :free_entrance, inclusion: { in: [true, false] }

  scope :current, -> { where('event_date >= ?', Time.current.beginning_of_day) }
  scope :expired, -> { where('event_date < ?', Time.current.beginning_of_day) }
  scope :some, -> { limit(SOME_LIMIT) }

  mount_uploader :poster, Uploader::EventImage

  def expired?
    return false if event_date.nil?
    last_date = event_date + duration.days
    !(last_date.today? || last_date.future?)
  end

  def recognized_external_urls
    result = {}
    URI.extract(external_urls || '', %w(http https)).map { |url| result[url] = URI.parse(url).host }
    result
  end
end
