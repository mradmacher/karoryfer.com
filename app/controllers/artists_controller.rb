# frozen_string_literal: true

class ArtistsController < CurrentArtistController
  layout 'current_artist', except: %i[index new create]

  def index
    @presenters = ArtistPresenter.presenters_for(Artist.all)
  end

  def show
    @presenter = ArtistPresenter.new(find)
  end

  private

  def find
    Artist.find_by_reference(params[:id])
  end
end
