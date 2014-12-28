class CurrentArtistController < ApplicationController
  include CrudableController

  before_filter do
    @artist_presenter = ArtistPresenter.new(current_artist, abilities)
  end

  protected

  def edit_view
    'shared/edit'
  end
end
