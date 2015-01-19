class Track < ActiveRecord::Base
  TITLE_MAX_LENGTH = 80
  COMMENT_MAX_LENGTH = 255

  belongs_to :album
  has_many :releases

  validates :title, :presence => true, :length => {:maximum => TITLE_MAX_LENGTH}
  validates :album_id, :presence => true
  validates :rank, :presence => true, :uniqueness => { :scope => :album_id }
  validates :comment, :length => {:maximum => COMMENT_MAX_LENGTH}

  default_scope -> { order( 'rank asc' ) }

  class Uploader < CarrierWave::Uploader::Base
    cattr_accessor :store_dir

     def extension_white_list
       %w(wav)
     end

    def filename
      "#{secure_token}.#{file.extension}" if original_filename.present?
    end

    def store_dir
      File.join( @@store_dir, (model.id / 1000).to_s )
    end

    protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end
  end

  mount_uploader :file, Uploader
  before_destroy :remove_file!

  def artist
    album.artist unless album.nil?
  end

  def license
    album.license unless album.nil?
  end
end

