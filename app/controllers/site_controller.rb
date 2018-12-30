# frozen_string_literal: true

class SiteController < ApplicationController
  def home
    @artist_presenters = ArtistPresenter.presenters_for(Artist.shared.shuffle)
  end

  def albums
    @album_presenters = AlbumPresenter.presenters_for(Album.published.shared)
  end

  def artists
    @artist_presenters = ArtistPresenter.presenters_for(Artist.order(:name))
  end
end
