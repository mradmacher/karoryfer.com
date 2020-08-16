# frozen_string_literal: true

class Track < ApplicationRecord
  TITLE_MAX_LENGTH = 80
  COMMENT_MAX_LENGTH = 255

  belongs_to :album
  has_many :releases

  validates :title, presence: true, length: { maximum: TITLE_MAX_LENGTH }
  validates :album_id, presence: true
  validates :rank, presence: true, uniqueness: { scope: :album_id }
  validates :comment, length: { maximum: COMMENT_MAX_LENGTH }

  mount_uploader :ogg_preview, Uploader::TrackPreview
  mount_uploader :mp3_preview, Uploader::TrackPreview
  mount_uploader :file, Uploader::TrackSource

  default_scope -> { order('rank asc') }

  before_destroy :remove_file!
  before_destroy :remove_preview!

  def file=(value)
    if value.is_a? String
      path = Settings.filer.path_to(value)
      value = File.open(path) if path
    end
    super
  end

  def artist
    album&.artist
  end

  def license
    album&.license
  end

  def generate_preview!
    releaser = Releaser::TrackReleaser.new(self, publisher: Publisher.instance)
    releaser.with_release(Release::OGG) { |path| self.ogg_preview = File.open(path) }
    releaser.with_release(Release::MP3) { |path| self.mp3_preview = File.open(path) }
    save
  end

  def preview?
    ogg_preview? && mp3_preview?
  end

  def remove_preview!
    self.remove_ogg_preview = true
    self.remove_mp3_preview = true
    save
  end
end
