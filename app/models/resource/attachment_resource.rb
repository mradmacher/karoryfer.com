module Resource
  # Provides access to attachment resource.
  class AttachmentResource < RegularResource

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
end




