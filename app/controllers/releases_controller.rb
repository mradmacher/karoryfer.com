# frozen_string_literal: true

class ReleasesController < CurrentAlbumController
  layout :set_layout

  def index
    @presenter = ReleasePresenter.new(cruder.new)
    @presenters = ReleasePresenter.presenters_for(cruder.index)
  end

  def show
    @presenter = ReleasePresenter.new(cruder.show)
  end

  def edit
    @presenter = ReleasePresenter.new(cruder.edit)
    render :edit
  end

  def new
    @presenter = ReleasePresenter.new(cruder.new)
    render :index
  end

  def update
    cruder.update
    redirect_to artist_album_releases_url(current_artist, current_album)
  rescue Crudable::InvalidResource => e
    @presenter = ReleasePresenter.new(e.resource)
    render :edit
  end

  def create
    cruder.create
    redirect_to artist_album_releases_url(current_artist, current_album)
  rescue Crudable::InvalidResource => e
    @presenter = ReleasePresenter.new(e.resource)
    render :index
  end

  def destroy
    cruder.destroy
    redirect_to artist_album_releases_url(current_artist, current_album)
  end

  private

  def policy_class
    ReleasePolicy
  end

  def cruder
    ReleaseCruder.new(policy_class.new(current_user.resource), params, current_album)
  end
end
