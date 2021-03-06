# frozen_string_literal: true

class ArtistPresenter < Presenter
  def_delegators(:resource, :name, :summary, :description, :image?, :image)

  alias artist resource
  alias title name

  def path
    artist_path(resource)
  end

  def delete_path
    admin_artist_path(resource)
  end

  def edit_path
    edit_admin_artist_path(resource)
  end

  def new_page_path
    new_admin_artist_page_path(artist)
  end

  def new_album_path
    new_admin_artist_album_path(artist)
  end

  def albums_path
    artist_albums_path(artist)
  end

  def pages_path
    admin_artist_pages_path(artist)
  end

  def recent_pages
    @recent_pages ||= PagePresenter.presenters_for(artist.pages.some)
  end

  def recent_albums
    @recent_albums ||= AlbumPresenter.presenters_for(artist.albums.published)
  end

  def albums_count
    artist.albums.published.count
  end

  def pages_count
    artist.pages.count
  end

  def show_albums?
    !recent_albums.empty?
  end

  def show_pages?
    !recent_pages.empty?
  end
end
