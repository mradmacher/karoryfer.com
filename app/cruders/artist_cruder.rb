# Provides access to artist resource.
class ArtistCruder < SimpleCruder
  def find
    Artist.find_by_reference(params[:id])
  end

  def build
    Artist.new
  end

  def search
    Artist.all
  end

  def permissions(action)
    case action
    when :index then [:read, :artist]
    when :show then [:read, find]
    when :new then [:write, :artist]
    when :edit then [:write, find]
    when :create then [:write, :artist]
    when :update then [:write, find]
    when :destroy then [:write, find]
    end
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
