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
      :license_name

    def copyright
      "#{@year} #{@artist}"
    end

    def copyright_description
      "Licensed to the public under #{@license_name} verify at #{@contact_url}"
    end

    def apply_to( file_path )
      for_file( file_path ) do |tag|
        apply_common( tag ) if tag
        if tag.is_a?  TagLib::Ogg::XiphComment
          apply_xiph_specific( tag )
        elsif tag.is_a? TagLib::ID3v2::Tag
          apply_id3v2_specific( tag )
        end
      end
    end

    private

    def for_file( file_path )
      extname = File.extname( file_path )
      case extname
        when '.ogg'
          for_ogg( file_path ) { |tag| yield tag }
        when '.flac'
          for_flac( file_path ) { |tag| yield tag }
        when '.mp3'
          for_mp3( file_path ) { |tag| yield tag }
      end
    end

    def for_ogg( file_path )
      TagLib::Ogg::Vorbis::File.open( file_path ) do |file|
        yield file.tag
        file.save
      end
    end

    def for_flac( file_path )
      TagLib::FLAC::File.open( file_path ) do |file|
        yield file.xiph_comment
        file.save
      end
    end

    def for_mp3( file_path )
      TagLib::ID3v2::FrameFactory.instance.default_text_encoding = TagLib::String::UTF8
      TagLib::MPEG::File.open( file_path ) do |file|
        yield file.id3v2_tag( true )
        file.save( TagLib::MPEG::File::ID3v2, true )
      end
    end

    def apply_common( tag )
      tag.artist = @artist
      tag.album = @album
      tag.year = @year
      tag.title = @title
      tag.track = @track
      tag.comment = @comment unless @comment.blank?
    end

    def apply_xiph_specific( tag )
      tag.add_field( 'CONTACT', @contact_url, true )
      tag.add_field( 'ORGANIZATION', @organization_name, true )
      unless @license_name.nil?
        tag.add_field( 'LICENSE', @license_name, true )
        tag.add_field( 'COPYRIGHT', self.copyright, true )
      end
    end

    def apply_id3v2_specific( tag )
      tag.genre = 'Other'

      frame = TagLib::ID3v2::UrlLinkFrame.new( 'WPUB' )
      frame.url = @organization_url
      tag.add_frame( frame )

      frame = TagLib::ID3v2::TextIdentificationFrame.new( 'TPUB', TagLib::String::UTF8 )
      frame.text = @organization_name
      tag.add_frame( frame )

      unless @license_name.nil?
        frame = TagLib::ID3v2::UrlLinkFrame.new( 'WCOP' )
        frame.url = @license_name
        tag.add_frame( frame )

        frame = TagLib::ID3v2::UrlLinkFrame.new( 'WOAF' )
        frame.url = @contact_url
        tag.add_frame( frame )

        frame = TagLib::ID3v2::TextIdentificationFrame.new( 'TCOP', TagLib::String::UTF8 )
        frame.text = self.copyright + '. ' + self.copyright_description
        tag.add_frame( frame )
      end
    end
  end

  class Generator
    attr_accessor :input

    def initialize(input)
      @input = input
    end

    def gen_ogg( output, quality )
      system  "oggenc #{@input} -q #{quality} -o #{output}.ogg"
    end

    def gen_mp3( output, quality )
      system "lame -V #{quality} #{@input} #{output}.mp3"
    end

    def gen_flac( output )
      system "flac #{@input} -o #{output}.flac"
    end
  end

  class Base
    cattr_accessor :publisher_name, :publisher_host

    def publisher_name
      @@publisher_name
    end

    def publisher_host
      @@publisher_host
    end

    def publisher_url
      "http://#{@@publisher_host}"
    end

    protected
    def format
      @format
    end

    def generate_track( track, output_path )
      FileUtils.mkdir_p output_path

      input = track.file.current_path
      output = File.join( output_path, track_file_basename( track ) )

      generator = Releaser::Generator.new( input )
      case self.format
        when 'flac'
          generator.gen_flac( output )
          tag_for( track ).apply_to( "#{output}.flac" )
        when 'ogg'
          generator.gen_ogg( output, self.ogg_quality )
          tag_for( track ).apply_to( "#{output}.ogg" )
        when 'mp3'
          generator.gen_mp3( output, self.mp3_quality )
          tag_for( track ).apply_to( "#{output}.mp3" )
      end
    end

    def underscore(name)
      name.parameterize '_'
    end

    def tag_for( track )
      tag = Releaser::Tag.new
      tag.artist = track.artist.name
      tag.album = track.album.title
      tag.year = track.album.year
      tag.title = track.title
      tag.track = track.rank
      tag.comment = track.comment unless track.comment.blank?

      tag.contact_url = self.release_url
      tag.organization_name = self.publisher_name
      tag.organization_url = self.publisher_url
      tag.license_name = track.license.name if track.license
      tag
    end

  end
end

