class Album < ActiveRecord::Base
  TITLE_MAX_LENGTH = 40
  REFERENCE_MAX_LENGTH = 40

  SOME_LIMIT = 4

  belongs_to :artist
  has_many :tracks, dependent: :destroy
  has_many :attachments, dependent: :destroy
  has_many :releases

  before_destroy do
    return false unless releases.empty?
  end

  validates :artist_id, :title, presence: true
  validates :title, length: { maximum: TITLE_MAX_LENGTH }
  validates :year, length: { is: 4 }
  validates :year, numericality: true
  validates :published, inclusion: { in: [true, false] }

  validates :reference, presence: true
  validates :reference, length: { maximum: REFERENCE_MAX_LENGTH }
  validates :reference, format: { with: /\A[a-z0-9]+([-]?[a-z0-9]+)*\z/ }
  validates :reference, uniqueness: { case_sensitive: false }

  mount_uploader :image, Uploader::AlbumImage

  default_scope -> { order('created_at desc') }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :shared, -> { where(shared: true) }
  scope :some, -> { limit(SOME_LIMIT) }

  def self.find_by_reference(ref)
    super ref.downcase
  end

  def to_param
    reference
  end

  def related
    artist.albums.published.delete_if { |a| a == self }
  end

  def license
    License.find(license_symbol)
  end
end

