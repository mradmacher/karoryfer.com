# frozen_string_literal: true

class AlbumsController < CurrentArtistController
  layout :set_layout

  def index
    @presenters = decorate_all(cruder.index)
  end

  def show
    @presenter = decorate(cruder.show)
  end

  def edit
    @presenter = decorate(cruder.edit)
    render :edit
  end

  def new
    @presenter = decorate(cruder.new)
    render :new
  end

  def update
    redirect_to decorate(cruder.update).path
  rescue Crudable::InvalidResource => e
    @presenter = decorate(e.resource)
    render :edit
  end

  def create
    redirect_to decorate(cruder.create).path
  rescue Crudable::InvalidResource => e
    @presenter = decorate(e.resource)
    render :new
  end

  def destroy
    redirect_to artist_albums_url(current_artist)
  end

  def download
    artist = Artist.find_by_reference(params[:artist_id])
    album = artist.albums.find_by_reference(params[:id])
    release = album.releases.in_format(params[:format]).first!
    if release.url
      release.increment!(:downloads)
      redirect_to release.url
    else
      redirect_to artist_album_url(@artist, @album)
    end
  end

  private

  def presenter_class
    AlbumPresenter
  end

  def policy_class
    AlbumPolicy
  end

  def cruder
    AlbumCruder.new(policy_class.new(current_user.resource), params, current_artist)
  end
end
