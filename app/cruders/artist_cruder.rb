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
      :summary_pl,
      :summary_en,
      :image,
      :remove_image,
      :description_pl,
      :description_en
    )
  end
end
