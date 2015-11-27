require 'taglib'

module Releaser
  class Tag
    attr_accessor :artist,
                  :album,
                  :year,
                  :title,
                  :track,
                  :comment,
                  :contact_url,
                  :organization_name,
                  :organization_url,
                  :license_name,
                  :copyright

    def copyright_description
      "Licensed to the public under #{@license_name} verify at #{@contact_url}"
    end

    def apply_to(file_path)
      for_file(file_path) do |tag|
        apply_common(tag) if tag
        if tag.is_a? TagLib::Ogg::XiphComment
          apply_xiph_specific(tag)
        elsif tag.is_a? TagLib::ID3v2::Tag
          apply_id3v2_specific(tag)
        end
      end
    end

    private

    def for_file(file_path)
      extname = File.extname(file_path)
      case extname
      when '.ogg'
        for_ogg(file_path) { |tag| yield tag }
      when '.flac'
        for_flac(file_path) { |tag| yield tag }
      when '.mp3'
        for_mp3(file_path) { |tag| yield tag }
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

    def apply_common(tag)
      tag.artist = @artist
      tag.album = @album
      tag.year = @year
      tag.title = @title
      tag.track = @track
      tag.comment = @comment unless @comment.blank?
    end

    def apply_xiph_specific(tag)
      tag.add_field('CONTACT', @contact_url, true)
      tag.add_field('ORGANIZATION', @organization_name, true)
      unless @license_name.nil?
        tag.add_field('LICENSE', @license_name, true)
        tag.add_field('COPYRIGHT', copyright, true)
      end
    end

    def apply_id3v2_specific(tag)
      tag.genre = 'Other'

      frame = TagLib::ID3v2::UrlLinkFrame.new('WPUB')
      frame.url = @organization_url
      tag.add_frame(frame)

      frame = TagLib::ID3v2::TextIdentificationFrame.new('TPUB', TagLib::String::UTF8)
      frame.text = @organization_name
      tag.add_frame(frame)

      unless @license_name.nil?
        frame = TagLib::ID3v2::UrlLinkFrame.new('WCOP')
        frame.url = @license_name
        tag.add_frame(frame)

        frame = TagLib::ID3v2::UrlLinkFrame.new('WOAF')
        frame.url = @contact_url
        tag.add_frame(frame)

        frame = TagLib::ID3v2::TextIdentificationFrame.new('TCOP', TagLib::String::UTF8)
        frame.text = copyright + '. ' + copyright_description
        tag.add_frame(frame)
      end
    end
  end
end
