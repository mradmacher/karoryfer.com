class SiteController < ApplicationController
  before_action :require_user, only: [:drafts]

  def home
    @artist_presenters = ArtistPresenter.presenters_for(Artist.shared.shuffle)
  end

  def albums
    @album_presenters = AlbumPresenter.presenters_for(Album.published.shared)
  end

  def artists
    @artist_presenters = ArtistPresenter.presenters_for(Artist.order(:name))
  end

  def drafts
    @album_presenters = AlbumPresenter.presenters_for(current_user.unpublished_albums)
  end
end
