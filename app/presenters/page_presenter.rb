# frozen_string_literal: true

class PagePresenter < Presenter
  def_delegators(:resource, :title, :content, :reference)

  def path
    artist_page_path(resource.artist, resource)
  end

  def edit_path
    edit_artist_page_path(resource.artist, resource)
  end
end
