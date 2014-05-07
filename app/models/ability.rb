class Ability
  attr_reader :user

  def initialize(user)
    @user = user || User.new
  end

  def allowed?(action, subject, scope = nil)
    user_actions_for(subject, scope).include? action
  end

  private
  def user_actions_for(subject, scope = nil)
    rules = []
    case subject.class.to_s
      when 'Post', 'Event', 'Video', 'Page'
        rules = [:read]
        if !user.memberships.select{ |m| m.artist_id == subject.artist_id }.empty?
          rules << :write
        end
      when 'Artist'
        rules = [:read]
        if user.admin?
          rules << :write
        elsif !user.memberships.select{ |m| m.artist_id == subject.id }.empty?
          rules << :write
        end
      when 'Attachment', 'Track'
        rules = []
        if user.admin?
          rules << :read
          rules << :write
        elsif subject.album.present?
          if subject.album.published?
            rules << :read
          elsif !user.memberships.select{ |m| m.artist_id == subject.album.artist_id }.empty?
            rules << :read
          end
        end
      when 'Album'
        rules = []
        if user.admin?
          rules << :read
          rules << :write
        elsif subject.published?
          rules << :read
        elsif !user.memberships.select{ |m| m.artist_id == subject.artist_id }.empty?
          rules << :read
        end
      when 'User'
        rules = [:read, :write] if user.admin? or user.id == subject.id
      when 'Membership'
        rules = [:read, :write] if user.admin? or user.id == subject.user_id
      when 'Class'
        if [Post, Video, Page, Event].include?(subject)
          if !scope.nil? && !user.memberships.select{ |m| m.artist_id == scope.id }.empty?
            rules = [:write]
          end
        elsif [Album].include?(subject)
          if user.admin? && !scope.nil? #&& !user.memberships.select{ |m| m.artist_id == scope.id }.empty?
            rules = [:write]
          end
        elsif [Attachment, Track].include?(subject)
          if user.admin? && !scope.nil? #&& !user.memberships.select{ |m| m.artist_id == scope.artist_id }.empty?
            rules = [:write]
          end
        elsif [Artist, User].include?(subject)
          if user.admin?
            rules = [:write]
          end
        elsif [Membership].include?(subject)
          if (scope.class == User) && ((user.admin? && !scope.nil?) || !user.memberships.select{ |m| m.user_id == scope.id }.empty?)
            rules = [:write]
          end
        end
      else
        rules = []
      end
    rules
  end
end

