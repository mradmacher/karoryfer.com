# Provides access to artist resource.
class ArtistCruder < SimpleCruder
  def list
    Artist.all
  end

  def find
    Artist.find_by_reference(params[:id])
  end

  def build
    Artist.new
  end

  def permitted_params
    strong_parameters.require(:artist).permit(
      :name,
      :reference,
      :summary,
      :image,
      :remove_image,
      :description
    )
  end
end
