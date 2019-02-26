# frozen_string_literal: true

class Admin::ReleasesController < AdminController
  layout :set_layout

  def index
    @presenter = ReleasePresenter.new(build)
    @presenters = ReleasePresenter.presenters_for(current_album.releases)
  end

  def show
    @presenter = ReleasePresenter.new(find)
  end

  def edit
    @presenter = ReleasePresenter.new(find)
    render :edit
  end

  def new
    @presenter = ReleasePresenter.new(build)
    render :index
  end

  def update
    release = find.tap { |r| r.assign_attributes(release_params) }
    if release.save
      redirect_to admin_artist_album_releases_url(current_artist, current_album)
    else
      @presenter = ReleasePresenter.new(release)
      render :edit
    end
  end

  def create
    release = build.tap { |r| r.assign_attributes(release_params) }
    if release.save
      redirect_to admin_artist_album_releases_url(current_artist, current_album)
    else
      @presenter = ReleasePresenter.new(release)
      render :index
    end
  end

  def destroy
    find.destroy
    redirect_to admin_artist_album_releases_url(current_artist, current_album)
  end

  private

  def find
    current_album.releases.find(params[:id])
  end

  def build
    current_album.releases.new
  end

  def release_params
    params.require(:release).permit(
      :album_id,
      :format,
      :file,
      :bandcamp_url,
      :for_sale,
      :price,
      :currency
    )
  end
end
