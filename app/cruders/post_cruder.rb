# Provides access to post resource.
class PostCruder < SimpleCruder
  attr_reader :artist

  def initialize(abilities, params, artist)
    super(abilities, params)
    @artist = artist
  end

  def find
    artist.posts.find(params[:id])
  end

  def build(attrs = {})
    artist.posts.new(attrs)
  end

  def search
    artist.posts
  end

  def permissions(action)
    case action
      when :index then [:read_post, artist]
      when :show then [:read_post, artist]
      when :new then [:write_post, artist]
      when :edit then [:write_post, artist]
      when :create then [:write_post, artist]
      when :update then [:write_post, artist]
      when :destroy then [:write_post, artist]
    end
  end

  def permitted_params
    strong_parameters.require(:post).permit(
      :title,
      :body
    )
  end
end
