# frozen_string_literal: true

# Provides access to release resource.
class ReleaseCruder < SimpleCruder
  alias album context

  def list
    album.releases
  end

  def find
    album.releases.find(params[:id])
  end

  def build
    album.releases.new
  end

  def permitted_params
    strong_parameters.require(:release).permit(
      :album_id,
      :format,
      :file,
      :bandcamp_url,
      :for_sale,
      :price,
      :currency
    )
  end
end
