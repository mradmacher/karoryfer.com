module Resource
  # Provides access to album resource.
  class AlbumResource < RegularResource

    protected

    def resource_class
      Album
    end

    def find_method
      :find_by_reference
    end

    def resource_scope
      owner.albums
    end

    def permitted_params
      strong_parameters.require(:album).permit(
        :published,
        :title,
        :reference,
        :year,
        :image,
        :remove_image,
        :license_id,
        :donation,
        :description
      )
    end
  end
end
