require 'singleton'

class Release < ActiveRecord::Base
  OGG = 'ogg'
  FLAC = 'flac'
  MP3 = 'mp3'
  FORMATS = [MP3, OGG, FLAC]

  belongs_to :album
  belongs_to :track

  after_destroy :remove_file!

  validate :owner_presence
  validates :format, presence: true
  validates :format, inclusion: {
    in: ['ogg', 'mp3', 'flac'] }, if: :generated?
  validates :file, presence: true, unless: :generated?

  mount_uploader :file, Uploader::Release

  scope :in_format, -> (format) { where( format: format ) }

  def generate!
    releaser = if owner.is_a? Album
      Releaser::AlbumReleaser.new(Publisher.instance, owner, format)
    elsif owner.is_a? Track
      Releaser::TrackReleaser.new(Publisher.instance, owner, format)
    end
    unless releaser.nil?
      releaser.generate do |release_file_path|
        self.file = File.open(release_file_path)
      end
      save
    end
  end

  def generate_in_background!
    argv = "release-#{owner.class.name}-#{owner.id}-#{format}"
    unless `ps aux`.include? argv
      Spawnling.new(argv: argv) do
        generate!
      end
    end
  end

  def owner=(owner)
    if owner.is_a? Album
      self.album = owner
      self.track = nil
    elsif owner.is_a? Track
      self.album = nil
      self.track = owner
    end
  end

  def owner
    if self.album.nil?
      self.track
    else
      self.album
    end
  end

  private

  def owner_presence
    self.errors[:base] << I18n.t('activerecord.errors.models.release.album_or_track.both') if
      self.album_id and self.track_id
    self.errors[:base] << I18n.t('activerecord.errors.models.release.album_or_track.none') unless
      self.album_id or self.track_id
  end
end
