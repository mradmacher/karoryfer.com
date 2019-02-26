# frozen_string_literal: true

module Releaser
  class AlbumReleaser < Releaser::Base
    def ogg_quality
      6
    end

    def mp3_quality
      1
    end

    def release_url
      return if releaseable.nil?

      Rails.application.routes.url_helpers.artist_album_url(
        releaseable.artist, releaseable, host: publisher.host
      )
    end

    def prepare_release(working_dir)
      album_dir = File.join(releaseable.artist.reference, releaseable.reference)
      output_dir = File.join(working_dir, album_dir)

      generate_files(output_dir)

      copy_attachments(output_dir)

      archive_name = "#{releaseable.artist.reference}-#{releaseable.reference}-#{format}.zip"
      make_archive(working_dir, archive_name)

      archive_name
    end

    private

    def generate_files(output_dir)
      releaseable.tracks.each do |track|
        generate_track(track, output_dir)
      end
    end

    def copy_attachments(output_dir)
      releaseable.attachments.each do |attachment|
        FileUtils.cp(attachment.file.current_path, output_dir)
      end
    end

    def make_archive(working_dir, archive_name)
      pwd = Dir.pwd
      Dir.chdir working_dir
      system "zip -rm #{archive_name} *"
      Dir.chdir pwd
    end

    def track_file_basename(track)
      "#{Kernel.format('%02d', track.rank)}-#{underscore(track.title)}"
    end
  end
end
