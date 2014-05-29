require 'singleton'

class Release < ActiveRecord::Base
  OGG = 'ogg'
  FLAC = 'flac'
  MP3 = 'mp3'
  FORMATS = [MP3, OGG, FLAC]

  belongs_to :album
  belongs_to :track

  before_save :generate
  after_destroy :remove_file!

  validate :if_album_or_track
  #validate :if_all_tracks_with_files
  validates :format, presence: true, inclusion: { in: FORMATS }

  mount_uploader :file, Uploader::Release

  def releaser
    if @releaser.nil?
      @releaser = if self.album
        AlbumReleaser.new( self.album, self.format )
      elsif self.track
        TrackReleaser.new( self.track, self.format )
      end
    end
    @releaser
  end

  scope :in_format, lambda { |format| where( format: format ) }

  def release_url
    self.releaser.release_url
  end

  def publisher_name
    self.releaser.publisher_name
  end

  def publisher_url
    self.releaser.publisher_url
  end

  def generate
    self.releaser.generate do |release_file_path|
      self.file = File.open( release_file_path )
    end
  end

  private

  def if_album_or_track
    self.errors[:base] << I18n.t( 'activerecord.errors.models.release.album_or_track.both' ) if
      self.album_id and self.track_id
    self.errors[:base] << I18n.t( 'activerecord.errors.models.release.album_or_track.none' ) unless
      self.album_id or self.track_id
  end

  def if_all_tracks_with_files
    without_file = false
    if self.track
      without_file = true if self.track.file.identifier.nil?
    elsif self.album
      self.album.tracks.each do |track|
        without_file = true if track.file.identifier.nil?
      end
    end
    self.errors[:base] << I18n.t( 'activerecord.errors.models.release.album_or_track.missing_files' ) if without_file
  end

end

