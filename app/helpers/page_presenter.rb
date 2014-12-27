class PagePresenter < ResourcePresenter
  def_delegators(:resource, :title, :content)

  def _path
    artist_page_path(resource.artist, resource)
  end

  def _edit_path
    edit_artist_page_path(resource.artist, resource)
  end
end
