# frozen_string_literal: true

class SiteController < ApplicationController
  def home
    @artist_presenters = ArtistPresenter.presenters_for(Artist.shared.shuffle)
  end

  def albums
    @artist_presenters = ArtistPresenter.presenters_for(Artist.shared.order(:name))
    @album_presenters = AlbumPresenter.presenters_for(Album.by_shared_artist.order(:year))
  end
end
