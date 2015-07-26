# Provides access to release resource.
class ReleaseCruder < SimpleCruder
  attr_reader :album

  def initialize(abilities, params, album)
    super(abilities, params)
    @album = album
  end

  def find
    album.releases.find(params[:id])
  end

  def build(attrs = {})
    album.releases.new(attrs)
  end

  def search
    album.releases
  end

  def permissions(action)
    case action
      when :index then [:read_release, album]
      when :show then [:read_release, album]
      when :new then [:write_release, album]
      when :edit then [:write_release, album]
      when :create then [:write_release, album]
      when :update then [:write_release, album]
      when :destroy then [:write_release, album]
    end
  end

  def permitted_params
    strong_parameters.require(:release).permit(:album_id, :format, :file)
  end
end
