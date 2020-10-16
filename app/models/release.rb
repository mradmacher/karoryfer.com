# frozen_string_literal: true

class Release < ApplicationRecord
  OGG = 'ogg'
  FLAC = 'flac'
  MP3 = 'mp3'
  ZIP = 'zip'
  EXTERNAL = 'external'
  CD = 'cd'
  FORMATS = [MP3, OGG, FLAC, ZIP, EXTERNAL, CD].freeze

  include Priceable

  belongs_to :album
  has_many :purchases
  has_many :download_events

  before_destroy :remove_file!

  validates :album_id, presence: true
  validates :format, presence: true
  validates :format, inclusion: { in: FORMATS }
  validates :external_url, format: %r{\Ahttps?://\w+}, allow_blank: true
  validates :whole_price, presence: true, if: :saleable?
  validates :currency, presence: true, if: :saleable?
  validate :validate_source

  mount_uploader :file, Uploader::Release

  scope :in_format, ->(format) { where(format: format) }

  def price_and_currency(discount)
    return [price, currency] if discount.nil?

    [discount.price, discount.currency]
  end

  def physical?
    format == CD
  end

  def digital?
    !physical?
  end

  def file_name
    File.basename(file.path) if file?
  end

  def generate!
    releaser = Releaser::AlbumReleaser.new(album, publisher: Publisher.instance)
    releaser.with_release(format) do |release_file_path|
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

  def purchased?(purchase)
    id == purchase&.release_id
  end

  def external?
    external_release?
  end

  private

  def saleable?
    for_sale? && published?
  end

  def validate_source
    return true unless file.blank? && external_url.blank?

    errors.add(:file, I18n.t('activerecord.errors.models.release.attributes.file.blank'))
    errors.add(:external_url, I18n.t('activerecord.errors.models.release.attributes.external_url.blank'))
  end

  def zip_release?
    format == ZIP
  end

  def external_release?
    format == EXTERNAL
  end
end
