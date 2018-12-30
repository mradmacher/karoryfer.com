# frozen_string_literal: true

class TracksController < CurrentAlbumController
  layout :set_layout

  def show
    redirect_to find.file.url
  end

  private

  def find
    current_album.tracks.find(params[:id])
  end
end
