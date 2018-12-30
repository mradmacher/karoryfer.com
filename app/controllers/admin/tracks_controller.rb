# frozen_string_literal: true

class Admin::TracksController < AdminController
  layout :set_layout

  def index
    @presenter = TrackPresenter.new(build)
    @presenters = TrackPresenter.presenters_for(current_album.tracks)
  end

  def edit
    @presenter = TrackPresenter.new(find)
    render :edit
  end

  def new
    @presenter = TrackPresenter.new(build)
    render :index
  end

  def update
    track = find.tap { |t| t.assign_attributes(track_params) }
    if track.save
      redirect_to admin_artist_album_tracks_url(current_artist, current_album)
    else
      @presenter = TrackPresenter.new(track)
      render :edit
    end
  end

  def create
    track = build.tap { |t| t.assign_attributes(track_params) }
    if track.save
      redirect_to admin_artist_album_tracks_url(current_artist, current_album)
    else
      @presenter = TrackPresenter.new(track)
      render :index
    end
  end

  def destroy
    find.destroy
    redirect_to admin_artist_album_tracks_url(current_artist, current_album)
  end

  private

  def track_params
    params.require(:track).permit(
      :artist_name,
      :title,
      :rank,
      :comment,
      :lyrics,
      :file,
      :remove_file
    )
  end

  def find
    current_album.tracks.find(params[:id])
  end

  def build
    current_album.tracks.new
  end
end
