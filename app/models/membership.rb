class Membership < ActiveRecord::Base
  belongs_to :artist
  belongs_to :user

  validates_presence_of :user_id, :artist_id
end

