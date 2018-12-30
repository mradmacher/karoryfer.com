# frozen_string_literal: true

class Admin::AlbumsController < AdminController
  layout :set_layout

  def edit
    @presenter = AlbumPresenter.new(find)
    render :edit
  end

  def new
    @presenter = AlbumPresenter.new(build)
    render :new
  end

  def update
    album = find.tap { |a| a.assign_attributes(album_params) }
    @presenter = AlbumPresenter.new(album)
    if album.save
      redirect_to @presenter.path
    else
      render :edit
    end
  end

  def create
    album = build.tap { |a| a.assign_attributes(album_params) }
    @presenter = AlbumPresenter.new(album)
    if album.save
      redirect_to @presenter.path
    else
      render :new
    end
  end

  def destroy
    find.destroy
    redirect_to artist_albums_url(current_artist)
  end

  private

  def album_params
    params.require(:album).permit(
      %i[
        artist_id
        title
        reference
        year
        image
        remove_image
        license_symbol
        donation
        description
        published
      ]
    )
  end

  def find
    current_artist.albums.find_by_reference(params[:id])
  end

  def build
    current_artist.albums.new
  end
end
