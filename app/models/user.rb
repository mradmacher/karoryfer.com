class User < ActiveRecord::Base
	acts_as_authentic do |c|
		c.validate_email_field = false
	end

  has_many :memberships

	attr_accessible :login, :email, :password, :password_confirmation, :as => [:default, :admin]
	attr_accessible :admin, :as => :admin
	validates :admin, :inclusion => { :in => [true, false] }

	def unpublished_posts
		self.admin? ? Post.unpublished.all : []
	end

	def unpublished_events
		self.admin? ? Event.unpublished.all : []
	end


  def unpublished_albums
    self.admin? ? Album.unpublished.all : []
  end

	def to_param
		"#{id},#{login.parameterize}"
	end
end
