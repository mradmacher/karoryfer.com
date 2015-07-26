# Provides access to page resource.
class PageCruder < SimpleCruder
  attr_reader :artist

  def initialize(abilities, params, artist)
    super(abilities, params)
    @artist = artist
  end

  def find
    artist.pages.find_by_reference(params[:id])
  end

  def build(attrs = {})
    artist.pages.new(attrs)
  end

  def search
    artist.pages
  end

  def permissions(action)
    case action
      when :index then [:read_page, artist]
      when :show then [:read_page, artist]
      when :new then [:write_page, artist]
      when :edit then [:write_page, artist]
      when :create then [:write_page, artist]
      when :update then [:write_page, artist]
      when :destroy then [:write_page, artist]
    end
  end

  def permitted_params
    strong_parameters.require(:page).permit(
      :title,
      :reference,
      :content
    )
  end
end
