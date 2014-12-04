module Resource
  # Provides access to artist resource.
  class ArtistResource < RegularResource

    protected

    def resource_class
      Artist
    end

    def find_method
      :find_by_reference
    end

    def permitted_params
      strong_parameters.require(:artist).permit(
        :name,
        :reference,
        :summary,
        :image,
        :remove_image,
        :description
      )
    end
  end
end
