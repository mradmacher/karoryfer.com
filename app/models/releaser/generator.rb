# frozen_string_literal: true

module Releaser
  class Generator
    def within_tmp_dir
      Dir.mktmpdir do |tmp_dir|
        yield tmp_dir
      end
    end

    def generate_track(input_path, output_dir, output_basename, tags:, format:, quality:)
      return unless %w[flac ogg mp3].include?(format)

      FileUtils.mkdir_p(output_dir)
      output_path = File.join(output_dir, "#{output_basename}.#{format}")

      case format
      when 'flac'
        gen_flac(input_path, output_path)
      when 'ogg'
        gen_ogg(input_path, output_path, quality)
      when 'mp3'
        gen_mp3(input_path, output_path, quality)
      end
      tagger.apply_to(output_path, tags)
    end

    private

    def tagger
      @tagger ||= ::Releaser::Tagger.new
    end

    def gen_ogg(input, output, quality)
      system "oggenc #{input} -q #{quality} -o #{output}"
    end

    def gen_mp3(input, output, quality)
      system "lame -V #{quality} #{input} #{output}"
    end

    def gen_flac(input, output)
      system "flac #{input} -o #{output}"
    end
  end
end
