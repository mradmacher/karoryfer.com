class CurrentArtistController < ApplicationController
  include CrudableController

  helper_method :artist

  protected

  def artist
    @artist_presenter ||= ArtistPresenter.new(current_artist)
  end

  def edit_view
    'shared/edit'
  end
end
