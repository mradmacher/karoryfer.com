# Provides access to album resource.
class AlbumCruder < Cruder
  def resource_class
    Album
  end

  def presenter_class
    AlbumPresenter
  end

  def find_method
    :find_by_reference
  end

  def resource_scope
    if abilities.allow?(:write, Album, owner)
      owner.albums
    else
      owner.albums.published
    end
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
