module Resource
  # Provides access to page resource.
  class PageResource < RegularResource

    protected

    def resource_class
      Page
    end

    def resource_scope
      owner.pages
    end

    def find_method
      :find_by_reference
    end

    def permitted_params
      strong_parameters.require(:page).permit(
        :title,
        :reference,
        :content
      )
    end
  end
end

