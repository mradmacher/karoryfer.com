module Releaser
  class TrackReleaser < Releaser::Base
    def ogg_quality
      3
    end

    def mp3_quality
      6
    end

    def release_url
      unless releaseable.nil?
        Rails.application.routes.url_helpers.artist_album_url(
          releaseable.artist, releaseable.album, :host => publisher.host)
      end
    end

    def prepare_release(working_dir)
      output_dir = working_dir
      generate_files(output_dir)
      "#{track_file_basename(releaseable)}.#{format}"
    end

    private

    def generate_files(output_dir)
      generate_track(releaseable, output_dir)
    end

    def track_file_basename(track)
      track.id.to_s
    end
  end
end

