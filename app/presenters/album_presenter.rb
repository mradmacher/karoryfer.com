class AlbumPresenter < Presenter
  def_delegators(:resource,
                 :title,
                 :published?,
                 :image?,
                 :image,
                 :license,
                 :year,
                 :donation,
                 :description,
                 :artist,
                 :releases,
                 :tracks,
                 :attachments)

  alias_method :album, :resource

  def path
    artist_album_path(album.artist, album)
  end

  def edit_path
    edit_artist_album_path(album.artist, album)
  end
end
