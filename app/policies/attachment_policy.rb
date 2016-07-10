class AttachmentPolicy < ApplicationPolicy
  def read?(attachment)
    album_policy.read?(attachment.album)
  end

  def write?(attachment)
    album_policy.write?(attachment.album)
  end

  def read_access?
    album_policy.read_access?
  end

  def write_access?
    album_policy.write_access?
  end

  private

  def album_policy
    @album_policy ||= AlbumPolicy.new(current_user)
  end
end
