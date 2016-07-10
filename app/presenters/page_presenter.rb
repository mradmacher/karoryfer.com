class PagePresenter < Presenter
  def_delegators(:resource, :title, :content)

  def path
    artist_page_path(resource.artist, resource)
  end

  def edit_path
    edit_artist_page_path(resource.artist, resource)
  end
end
