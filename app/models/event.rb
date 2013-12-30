class Event < ActiveRecord::Base
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

  class Uploader < CarrierWave::Uploader::Base
    #include CarrierWave::MiniMagick
    cattr_accessor :store_dir

     def extension_white_list
       %w(jpg jpeg png gif)
     end

    def filename
      if original_filename
        if model && model.read_attribute(mounted_as).present?
          model.read_attribute(mounted_as)
        else
          "#{secure_token}.#{file.extension}"
        end
      end
    end

    def store_dir
      File.join( @@store_dir, (model.id / 1000).to_s )
    end

    protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)

      #model.image_secure_token ||= SecureRandom.uuid
    end
  end
  #mount_uploader :file, Uploader
  #before_destroy :remove_file!

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
    return result if external_urls.blank?
    external_urls.split( /\s/ ).each do |url|
      result[url] = :facebook if /facebook.com/ =~ url
    end
    result
  end

end

