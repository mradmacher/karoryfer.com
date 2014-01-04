class Attachment < ActiveRecord::Base
  belongs_to :album

  validates :album_id, presence: true
	validate :validate_file, :presence => true, :uniqueness => { :scope => :album_id }
  before_destroy :remove_file!

  class Uploader < CarrierWave::Uploader::Base
    cattr_accessor :store_dir

    def store_dir
      File.join( @@store_dir, model.album.id.to_s )
    end
  end

  mount_uploader :file, Uploader

  private
  def validate_file
    if self.file.identifier.nil?
      errors.add(:file, I18n.t( 'activerecord.errors.models.attachment.attributes.file.blank' ) )
    end
    if self.album_id
      similar = Attachment.where( album_id: self.album_id, file: self.file.identifier )
      similar = similar.where('id <> ?', self.id) if self.id

      if similar.exists?
        errors.add(:file, I18n.t( 'activerecord.errors.models.attachment.attributes.file.taken' ) )
      end
    end
  end
end
