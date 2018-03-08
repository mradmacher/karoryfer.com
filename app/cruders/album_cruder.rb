# frozen_string_literal: true

# Provides access to album resource.
class AlbumCruder < SimpleCruder
  alias artist context

  def list
    artist.albums.published
  end

  def find
    artist.albums.find_by_reference(params[:id])
  end

  def build
    artist.albums.new
  end

  def permitted_params
    fields = %i[
      artist_id
      title
      reference
      year
      image
      remove_image
      license_symbol
      donation
      description
    ]
    fields << :published if policy.write_access?
    strong_parameters.require(:album).permit(fields)
  end
end
