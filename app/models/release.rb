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

  after_destroy :remove_file!

  validates :album_id, presence: true
  validates :format, presence: true
  validates :format, inclusion: { in: FORMATS }
  validates :file, presence: true, if: :zip_release?
  validates :external_url, format: %r{\Ahttps?://\w+}, if: :external_release?
  validates :whole_price, presence: true, if: :for_sale?
  validates :currency, presence: true, if: :for_sale?

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

  def url
    format == EXTERNAL ? external_url : file&.url
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

  def purchased?(purchase)
    id == purchase&.release_id
  end

  def external?
    external_release?
  end

  private

  def zip_release?
    format == ZIP
  end

  def external_release?
    format == EXTERNAL
  end
end
