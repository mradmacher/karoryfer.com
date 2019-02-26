# frozen_string_literal: true

class TrackPresenter < Presenter
  def_delegators(:resource,
                 :id,
                 :title,
                 :rank,
                 :artist_name,
                 :comment,
                 :lyrics,
                 :preview?,
                 :ogg_preview,
                 :mp3_preview,
                 :file,
                 :file?)

  def available_files
    Settings.filer.list('*.wav')
  end

  def html_lyrics
    lyrics.gsub("\n", '<br />').html_safe
  end

  def path
    admin_artist_album_track_path(resource.album.artist, resource.album, resource)
  end

  def edit_path
    edit_admin_artist_album_track_path(resource.album.artist, resource.album, resource)
  end
end
