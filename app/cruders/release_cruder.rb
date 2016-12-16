# Provides access to release resource.
class ReleaseCruder < SimpleCruder
  alias_method :album, :context

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
    strong_parameters.require(:release).permit(:album_id, :format, :file, :bandcamp_url)
  end
end
