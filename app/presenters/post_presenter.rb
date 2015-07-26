class PostPresenter < Presenter
  def_delegators(:resource, :title, :body, :artist)

  def path
    artist_post_path(resource.artist, resource)
  end

  def date
    resource.created_at
  end

  def edit_path
    edit_artist_post_path(resource.artist, resource)
  end

  def can_be_updated?
    abilities.allow?(:write_post, resource.artist)
  end

  def can_be_deleted?
    can_be_updated?
  end
end
