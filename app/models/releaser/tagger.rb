# frozen_string_literal: true

require 'taglib'

module Releaser
  class Tagger
    def apply_to(file_path, tags)
      for_file(file_path) do |file_tags|
        apply_common(file_tags, tags) if file_tags
        if file_tags.is_a?(TagLib::Ogg::XiphComment)
          apply_xiph_specific(file_tags, tags)
        elsif file_tags.is_a?(TagLib::ID3v2::Tag)
          apply_id3v2_specific(file_tags, tags)
        end
      end
    end

    private

    def for_file(file_path)
      extname = File.extname(file_path)
      case extname
      when '.ogg'
        for_ogg(file_path) { |file_tags| yield file_tags }
      when '.flac'
        for_flac(file_path) { |file_tags| yield file_tags }
      when '.mp3'
        for_mp3(file_path) { |file_tags| yield file_tags }
      end
    end

    def for_ogg(file_path)
      TagLib::Ogg::Vorbis::File.open(file_path) do |file|
        yield file.tag
        file.save
      end
    end

    def for_flac(file_path)
      TagLib::FLAC::File.open(file_path) do |file|
        yield file.xiph_comment
        file.save
      end
    end

    def for_mp3(file_path)
      TagLib::ID3v2::FrameFactory.instance.default_text_encoding = TagLib::String::UTF8
      TagLib::MPEG::File.open(file_path) do |file|
        yield file.id3v2_tag(true)
        file.save(TagLib::MPEG::File::ID3v2, true)
      end
    end

    def apply_common(file_tags, tags)
      file_tags.artist = tags.artist
      file_tags.album = tags.album
      file_tags.year = tags.year
      file_tags.title = tags.title
      file_tags.track = tags.track
      file_tags.comment = tags.comment unless tags.comment.blank?
    end

    def apply_xiph_specific(file_tags, tags)
      file_tags.add_field('CONTACT', tags.contact_url, true)
      file_tags.add_field('ORGANIZATION', tags.organization_name, true)
      return if tags.license_name.nil?

      file_tags.add_field('LICENSE', tags.license_name, true)
      file_tags.add_field('COPYRIGHT', tags.copyright, true)
    end

    def apply_id3v2_specific(file_tags, tags)
      frame = TagLib::ID3v2::UrlLinkFrame.new('WPUB')
      frame.url = tags.organization_url
      file_tags.add_frame(frame)

      frame = TagLib::ID3v2::TextIdentificationFrame.new('TPUB', TagLib::String::UTF8)
      frame.text = tags.organization_name
      file_tags.add_frame(frame)

      return if tags.license_name.nil?

      frame = TagLib::ID3v2::UrlLinkFrame.new('WCOP')
      frame.url = tags.license_name
      file_tags.add_frame(frame)

      frame = TagLib::ID3v2::UrlLinkFrame.new('WOAF')
      frame.url = tags.contact_url
      file_tags.add_frame(frame)

      frame = TagLib::ID3v2::TextIdentificationFrame.new('TCOP', TagLib::String::UTF8)
      frame.text = tags.copyright + '. ' + tags.copyright_description
      file_tags.add_frame(frame)
    end
  end
end
