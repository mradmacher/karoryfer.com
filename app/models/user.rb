class User < ActiveRecord::Base
  class AccessDenied < Exception
  end

	acts_as_authentic do |c|
		c.validate_email_field = false
	end

  has_many :memberships

	attr_accessible :login, :email, :password, :password_confirmation, :as => [:default, :admin]
	attr_accessible :admin, :as => :admin
	validates :admin, :inclusion => { :in => [true, false] }

  def artists
    Artist.joins( :memberships ).where( 'memberships.user_id' => self.id )
  end

  def other_artists
    artist_ids = self.artists.pluck(:id)
    if artist_ids.empty?
      Artist.all
    else
      Artist.where( 'id not in (?)', artist_ids )
    end
  end

	def unpublished_posts
    Post.joins( :artist ).joins( :artist => :memberships ).where( 'memberships.user_id' => self.id ).where( 'posts.published' => false )
	end

	def unpublished_events
    Event.joins( :artist ).joins( :artist => :memberships ).where( 'memberships.user_id' => self.id ).where( 'events.published' => false )
	end

  def unpublished_albums
    Album.joins( :artist ).joins( :artist => :memberships ).where( 'memberships.user_id' => self.id ).where( 'albums.published' => false )
  end

	def to_param
		"#{id},#{login.parameterize}"
	end
end
