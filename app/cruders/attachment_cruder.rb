# Provides access to attachment resource.
class AttachmentCruder < SimpleCruder
  alias_method :album, :context

  def list
    album.attachments
  end

  def find
    album.attachments.find(params[:id])
  end

  def build
    album.attachments.new
  end

  def permitted_params
    strong_parameters.require(:attachment).permit(:file)
  end
end
