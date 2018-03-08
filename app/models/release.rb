# frozen_string_literal: true

class Release < ActiveRecord::Base
  OGG = 'ogg'
  FLAC = 'flac'
  MP3 = 'mp3'
  ZIP = 'zip'
  BANDCAMP = 'bandcamp'
  FORMATS = [MP3, OGG, FLAC, ZIP, BANDCAMP].freeze

  belongs_to :album

  after_destroy :remove_file!

  validates :album_id, presence: true
  validates :format, presence: true
  validates :format, inclusion: { in: FORMATS }
  validates :file, presence: true, if: :zip_release?
  validates :bandcamp_url, format: %r{\Ahttps://\w+\.bandcamp\.com/album}, if: :bandcamp_release?

  mount_uploader :file, Uploader::Release

  scope :in_format, ->(format) { where(format: format) }

  def url
    format == BANDCAMP ? bandcamp_url : file&.url
  end

  def generate!
    releaser = Releaser::AlbumReleaser.new(Publisher.instance, album, format)
    releaser.generate do |release_file_path|
      self.file = File.open(release_file_path)
    end
    save
  end

  def file=(value)
    if value.is_a? String
      path = Settings.filer.path_to(value)
      value = File.open(path) if path
    end
    super
  end

  private

  def zip_release?
    format == ZIP
  end

  def bandcamp_release?
    format == BANDCAMP
  end
end
