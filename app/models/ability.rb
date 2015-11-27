class Ability
  attr_reader :user

  def initialize(user)
    @user = user || User.new
  end

  def allows?(action, subject)
    rules_for(subject).include?(action)
  end

  alias_method :allow?, :allows?

  private

  def rules
    @rules ||= {}
  end

  def rules_for(subject)
    if rules[subject].nil?
      subject_rules = []
      case subject.class.to_s
      when 'Artist'
        subject_rules.concat([
          :read,
          :read_post,
          :read_video,
          :read_page,
          :read_event,
          :read_album
        ])
        if member_of?(subject.id)
          subject_rules.concat([
            :write,
            :write_post,
            :write_video,
            :write_page,
            :write_event
          ])
          subject_rules.concat([:write_album]) if user.publisher?
        end
      when 'Album'
        if user.publisher? && member_of?(subject.artist_id)
          subject_rules.concat([
            :read,
            :read_attachment,
            :read_track,
            :read_release,
            :write,
            :write_attachment,
            :write_track,
            :write_release
          ])
        elsif subject.published? || member_of?(subject.artist_id)
          subject_rules.concat([:read, :read_attachment, :read_track])
        end
      when 'User'
        if user.admin?
          subject_rules.concat([
            :read,
            :read_membership,
            :write,
            :write_membership
          ])
        elsif user == subject
          subject_rules.concat([
            :read,
            :read_membership,
            :write,
            :write_membership
          ])
        end
      when 'Symbol'
        case subject
        when :artist
          subject_rules.concat([:read])
          if user.admin?
            subject_rules.concat([:write])
          end
        when :user
          if user.admin?
            subject_rules.concat([:write, :read])
          end
        end
      end
      rules[subject] = subject_rules
    end
    rules[subject]
  end

  def member_of?(artist_id)
    if @membership_ids.nil?
      @membership_ids = user.memberships.map(&:artist_id)
    end
    !@membership_ids.select { |id| id == artist_id }.empty?
  end
end
