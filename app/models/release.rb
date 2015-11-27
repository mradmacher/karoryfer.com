class Release < ActiveRecord::Base
  OGG = 'ogg'
  FLAC = 'flac'
  MP3 = 'mp3'
  ZIP = 'zip'
  FORMATS = [MP3, OGG, FLAC, ZIP]

  belongs_to :album

  after_destroy :remove_file!

  validates :album_id, presence: true
  validates :format, presence: true
  validates :format, inclusion: { in: FORMATS }
  validates :file, presence: true, unless: :generated?

  mount_uploader :file, Uploader::Release

  scope :in_format, -> (format) { where(format: format) }

  def generated?
    [MP3, OGG, FLAC].include?(format)
  end

  def generate!
    releaser = Releaser::AlbumReleaser.new(Publisher.instance, album, format)
    releaser.generate do |release_file_path|
      self.file = File.open(release_file_path)
    end
    save
  end

  def generate_in_background!
    argv = "release-#{album_id}-#{format}"
    Spawnling.new(argv: argv) { generate! } unless `ps aux`.include? argv
  end

  def file=(value)
    if value.is_a? String
      path = Settings.filer.path_to(value)
      value = File.open(path) if path
    end
    super
  end
end
