class Ability

	def self.allowed( user, subject )
    if user && user.admin?
      rules = [
        :read_post, :write_post,
        :read_event, :write_event,
        :read_video, :write_video,
        :read_artist, :write_artist,
        :read_album, :write_album,
        :read_user, :write_user,
        :read_page, :write_page
      ]
    else
      case subject.class.to_s
        when 'Post'
          rules = [:read_post] if subject.published?
        when 'Event'
          rules = [:read_event] if subject.published?
        when 'Video'
          rules = [:read_video]
        when 'Artist'
          rules = [:read_artist]
        when 'Album'
          rules = [:read_album] if subject.published?
        when 'Page'
          rules = [:read_page]
        when 'User'
          rules = [:read_user, :write_user] if user.id == subject.id
        else
          rules = []
        end
    end
    rules
  end
end

