# Provides access to attachment resource.
class AttachmentCruder < Cruder
  def resource_class
    Attachment
  end

  def presenter_class
    AttachmentPresenter
  end

  def resource_scope
    owner.attachments
  end

  def permitted_params
    strong_parameters.require(:attachment).permit(:file)
  end
end
