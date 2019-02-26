# frozen_string_literal: true

class Page < ApplicationRecord
  translates :title, :content, fallback: :any

  belongs_to :artist

  TITLE_MAX_LENGTH = 40

  validates :artist_id, :reference, :title, presence: true
  validates :reference, format: { with: /\A[a-z0-9]+(-[a-z0-9]+)*\z/ }
  validates :reference, uniqueness: { case_sensitive: false, scope: :artist_id }
  validates :title, length: { maximum: TITLE_MAX_LENGTH }

  scope :some, -> { all }

  def self.find_by_reference(ref)
    super(ref.downcase)
  end

  def self.get(ref)
    Page.find_or_initialize_by_reference(ref)
  end

  def to_param
    reference
  end

  def self.find(*args)
    if args.first.is_a? String
      find_by_reference(args.delete_at(0).downcase, args)
    else
      super(*args)
    end
  end
end
