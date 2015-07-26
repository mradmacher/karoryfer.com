# Provides access to attachment resource.
class AttachmentCruder < SimpleCruder
  attr_reader :album

  def initialize(abilities, params, album)
    super(abilities, params)
    @album = album
  end

  def find
    album.attachments.find(params[:id])
  end

  def build(attrs = {})
    album.attachments.new(attrs)
  end

  def search
    album.attachments
  end

  def permissions(action)
    case action
      when :index then [:read_attachment, album]
      when :show then [:read_attachment, album]
      when :new then [:write_attachment, album]
      when :edit then [:write_attachment, album]
      when :create then [:write_attachment, album]
      when :update then [:write_attachment, album]
      when :destroy then [:write_attachment, album]
    end
  end

  def permitted_params
    strong_parameters.require(:attachment).permit(:file)
  end
end
