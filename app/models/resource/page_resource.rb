module Resource
  # Provides access to page resource.
  class PageResource < RegularResource
    def resource_class
      Page
    end

    def permitted_params
      strong_parameters.require(:page).permit(
        :title,
        :reference,
        :content
      )
    end

    protected

    def resource_scope
      owner.pages
    end

    def find_method
      :find_by_reference
    end
  end
end

