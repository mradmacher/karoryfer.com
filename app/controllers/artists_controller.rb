class ArtistsController < CurrentArtistController
  layout 'current_artist', except: [:index, :new, :create]

  private

  def edit_view
    'edit'
  end

  def destroy_redirect_path(_)
    artists_url
  end

  def cruder
    ArtistCruder.new(abilities, params)
  end
end
