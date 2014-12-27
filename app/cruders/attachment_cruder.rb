# Provides access to attachment resource.
class AttachmentCruder < Cruder

  protected

  def resource_class
    Attachment
  end

  def resource_scope
    owner.attachments
  end

  def permitted_params
    strong_parameters.require(:attachment).permit(:file)
  end
end
