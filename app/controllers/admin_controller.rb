# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :require_user
  helper_method :artist, :album

  protected

  def artist
    @artist_presenter ||= ArtistPresenter.new(current_artist)
  end

  def album
    @album_presenter ||= AlbumPresenter.new(current_album)
  end

  def current_album
    current_artist.albums.find_by_reference(params[:album_id])
  end

  def require_user
    raise User::AccessDenied unless current_user
  end
end
