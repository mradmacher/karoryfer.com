class Artist < ActiveRecord::Base
  has_many :posts
  has_many :events
  has_many :videos
  has_many :albums
  has_many :pages
  has_many :memberships

  NAME_MAX_LENGTH = 32
  REFERENCE_MAX_LENGTH = 24
  validates :name, presence: true
  validates :name, length: { maximum: NAME_MAX_LENGTH }

  validates :reference, presence: true
  validates :reference, length: { maximum: REFERENCE_MAX_LENGTH }
  validates :reference, format: { with: /\A[a-z0-9]+([-_]?[a-z0-9]+)*\z/ }
  validates :reference, uniqueness: { case_sensitive: false }
  validates :reference, exclusion: { in: %w(aktualnosci wydarzenia wiadomosci filmy wydawnictwa informacje artysci) }

  mount_uploader :image, Uploader::ArtistImage

  scope :shared, -> { where(shared: true) }

  def to_param
    reference
  end

  def self.find_by_reference(ref)
    super ref.downcase
  end
end
