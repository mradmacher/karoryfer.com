# Provides access to page resource.
class PageCruder < SimpleCruder
  alias_method :artist, :context

  def list
    artist.pages
  end

  def find
    artist.pages.find_by_reference(params[:id])
  end

  def build
    artist.pages.new
  end

  def permitted_params
    strong_parameters.require(:page).permit(
      :reference,
      :title_pl,
      :title_en,
      :content_pl,
      :content_en
    )
  end
end
