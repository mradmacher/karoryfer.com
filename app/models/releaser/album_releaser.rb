# frozen_string_literal: true

module Releaser
  class AlbumReleaser
    QUALITY = {
      Release::OGG => 10,
      Release::MP3 => 0
    }.freeze
    attr_reader :album, :publisher

    def initialize(album, publisher:)
      @album = album
      @publisher = publisher
    end

    def with_release(format)
      generator.within_tmp_dir do |working_dir|
        filename = prepare_release(working_dir, format)
        yield File.join(working_dir, filename)
      end
    end

    private

    def generator
      @generator ||= ::Releaser::Generator.new
    end

    def prepare_release(working_dir, format)
      album_dir = File.join(album.artist.reference, album.reference)
      output_dir = File.join(working_dir, album_dir)

      generate_files(output_dir, format)
      copy_attachments(output_dir)

      archive_name = "#{album.artist.reference}-#{album.reference}-#{format}.zip"
      make_archive(working_dir, archive_name)

      archive_name
    end

    def underscore(name)
      name.parameterize(separator: '_')
    end

    def generate_files(output_dir, format)
      album.tracks.each do |track|
        generator.generate_track(
          track.file.path,
          output_dir,
          track_file_basename(track),
          tags: ::Releaser::Tags.build_for(track, publisher: publisher),
          format: format,
          quality: QUALITY[format]
        )
      end
    end

    def copy_attachments(output_dir)
      album.attachments.each do |attachment|
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
