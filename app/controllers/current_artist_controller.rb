# frozen_string_literal: true

class CurrentArtistController < ApplicationController
  helper_method :artist

  protected

  def artist
    @artist_presenter ||= ArtistPresenter.new(current_artist)
  end
end
