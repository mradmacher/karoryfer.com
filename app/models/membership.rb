class Membership < ActiveRecord::Base
  belongs_to :artist
  belongs_to :user

  validates :user_id, :artist_id, presence: true
end

