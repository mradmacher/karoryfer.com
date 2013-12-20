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
        :read_page, :write_page,
        :write_membership
      ]
    else
      rules = []
      case subject.class.to_s
        when 'Post'
          rules = [:read_post] if subject.published?
          unless user.nil? || (subject.artist_id.present? && Membership.where(user_id: user.id, artist_id: subject.artist_id).empty?)
            rules << [:read_post, :write_post]
          end
        when 'Event'
          rules = [:read_event] if subject.published?
          unless user.nil? || (subject.artist_id.present? && Membership.where(user_id: user.id, artist_id: subject.artist_id).empty?)
            rules << [:read_event, :write_event]
          end
        when 'Video'
          rules = [:read_video]
          unless user.nil? || (subject.artist_id.present? && Membership.where(user_id: user.id, artist_id: subject.artist_id).empty?)
            rules << [:read_video, :write_video]
          end
        when 'Artist'
          rules = [:read_artist]
          unless user.nil? || Membership.where(user_id: user.id, artist_id: subject.id).empty?
            rules << [:write_artist]
          end
        when 'Album'
          rules = [:read_album] if subject.published?
        when 'Page'
          rules = [:read_page]
        when 'User'
          rules = [:read_user, :write_user] if user.id == subject.id
        when 'Class'
          unless user.nil? || Membership.where(user_id: user.id).empty?
            rules = [:write_event, :write_post, :write_video]
          end
        else
          rules = []
        end
    end
    rules
  end
end

