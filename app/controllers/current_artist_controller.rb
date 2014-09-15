class CurrentArtistController < ApplicationController
  before_filter do
    @current_artist_view = CurrentArtistView.new(current_artist, abilities)
  end
end

