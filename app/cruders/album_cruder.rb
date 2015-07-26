# Provides access to album resource.
class AlbumCruder < SimpleCruder
  attr_reader :artist

  def initialize(abilities, params, artist)
    super(abilities, params)
    @artist = artist
  end

  def find
    artist.albums.find_by_reference(params[:id])
  end

  def build(attrs = {})
    artist.albums.new(attrs)
  end

  def search
    artist.albums.published
  end

  def permissions(action)
    case action
      when :index then [:read_album, artist]
      when :show then [:read, find]
      when :new then [:write_album, artist]
      when :edit then [:write, find]
      when :create then [:write_album, artist]
      when :update then [:write, find]
      when :destroy then [:write, find]
    end
  end

  def permitted_params
    fields = [
      :title,
      :reference,
      :year,
      :image,
      :remove_image,
      :license_id,
      :donation,
      :description
    ]
    if abilities.allow?(:write_album, artist)
      fields << :published
    end
    strong_parameters.require(:album).permit(fields)
  end
end
