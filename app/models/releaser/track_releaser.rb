# frozen_string_literal: true

module Releaser
  class TrackReleaser
    QUALITY = {
      Release::OGG => 3,
      Release::MP3 => 6
    }.freeze
    attr_reader :track, :publisher

    def initialize(track, publisher:)
      @track = track
      @publisher = publisher
    end

    def with_release(format)
      generator.within_tmp_dir do |tmp_dir|
        filename = prepare_release(tmp_dir, format)
        yield File.join(tmp_dir, filename)
      end
    end

    private

    def prepare_release(working_dir, format)
      output_dir = working_dir
      generate_files(output_dir, format)
      "#{track_file_basename(track)}.#{format}"
    end

    def generator
      @generator ||= ::Releaser::Generator.new
    end

    def generate_files(output_dir, format)
      generator.generate_track(
        track.file.path,
        output_dir,
        track.id.to_s,
        tags: ::Releaser::Tags.build_for(track, publisher: publisher),
        format: format,
        quality: QUALITY[format]
      )
    end

    def track_file_basename(track)
      track.id.to_s
    end
  end
end
