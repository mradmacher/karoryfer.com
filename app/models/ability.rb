class Ability
  attr_reader :user

  def initialize(user)
    @user = user || User.new
  end

  def allowed?(action, subject, scope = nil)
    user_actions_for(subject, scope).include? action
  end

  alias :allow? :allowed?

  private
  def user_actions_for(subject, scope = nil)
    rules = []
    case subject.class.to_s
      when 'Post', 'Event', 'Video', 'Page'
        rules = [:read]
        if is_member_of?(subject.artist_id)
          rules << :write
        end
      when 'Artist'
        rules << :read
        if user.admin?
          rules << :write
        elsif is_member_of?(subject.id)
          rules << :write
        end
      when 'Attachment', 'Track'
        if subject.album.present?
          if is_member_of?(subject.album.artist_id)
            rules << :read
            rules << :write if user.publisher?
          elsif subject.album.published?
            rules << :read
          end
        end
      when 'Release'
        if subject.album.present? && is_member_of?(subject.album.artist_id) && user.publisher?
          rules << :read
          rules << :write
        end
      when 'Album'
        if is_member_of?(subject.artist_id)
          rules << :read
          rules << :write if user.publisher?
        elsif subject.published?
          rules << :read
        end
      when 'User'
        if user.admin? or user.id == subject.id
          rules << :read
          rules << :write
          rules << :manage if user.admin?
        end
      when 'Membership'
        if user.admin? or user.id == subject.user_id
          rules << :read
          rules << :write
        end
      when 'Class'
        case subject.to_s
          when 'Post', 'Video', 'Page', 'Event'
            rules << :read
            if !scope.nil? && is_member_of?(scope.id)
              rules << :write
            end
          when 'Album'
            rules << :read
            if user.publisher? && !scope.nil? && is_member_of?(scope.id)
              rules << :write
            end
          when 'Attachment', 'Track', 'Release'
            if user.publisher? && !scope.nil? && (scope.class == Album) && is_member_of?(scope.artist_id)
              rules << :read
              rules << :write
            end
          when 'Artist'
            rules << :read
            rules << :write if user.admin?
          when 'User'
            if user.admin?
              rules << :read
              rules << :write
            end
          when 'Membership'
            if (scope.class == User) && ((user.admin? && !scope.nil?) || is_member_of?(scope.id))
              rules << :write
            end
        end
      end
    rules
  end

  private
  def is_member_of?(artist_id)
    !user.memberships.select{ |m| m.artist_id == artist_id }.empty?
  end
end

