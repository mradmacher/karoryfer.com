class CurrentUserPresenter < Presenter
  def_delegators(:resource,
    :admin?, :publisher?,
    :memberships,
  )

  alias_method :current_user, :resource

  def unpublished_albums
    Album.joins(:artist).joins(artist: :memberships)
      .where('memberships.user_id' => current_user.id)
      .where('albums.published' => false)
  end

  def account_path
    admin_user_path(current_user)
  end

  def logout_path
    admin_logout_path
  end

  def login_path
    admin_login_path
  end

  def can_manage_album?(album)
    album_policy.write?(album)
  end

  def can_manage_attachments?(album)
    album_policy.write?(album)
  end

  def can_manage_tracks?(album)
    album_policy.write?(album)
  end

  def can_manage_releases?(album)
    album_policy.write?(album)
  end

  def can_manage_artist?(artist)
    artist_policy.write?(artist)
  end

  def can_manage_pages?(artist)
    artist_policy.write?(artist)
  end

  def can_create_album?(artist)
    album_policy.write_access? && artist_policy.write?(artist)
  end

  def can_create_artist?
    artist_policy.write_access?
  end

  def can_manage_users?
    user_policy.write_access? && current_user.admin?
  end

  def can_manage_account?
    user_policy.write_access? && user_policy.write?(current_user)
  end

  def can_manage_memberships?
    can_manage_users?
  end

  private

  def artist_policy
    @artist_policy ||= ArtistPolicy.new(current_user)
  end

  def album_policy
    @album_policy ||= AlbumPolicy.new(current_user)
  end

  def user_policy
    @user_policy ||= UserPolicy.new(current_user)
  end
end
