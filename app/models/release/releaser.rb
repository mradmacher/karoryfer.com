class Release
  class Releaser
    attr_reader :publisher, :releaseable, :format

    def initialize(publisher, releaseable, format)
      @publisher = publisher
      @releaseable = releaseable
      @format = format
    end

    def ogg_quality
      6
    end

    def mp3_quality
      1
    end

    def release_url
      nil
    end

    def generate
      Dir.mktmpdir do |working_dir|
        filename = prepare_release( working_dir )
        yield File.join( working_dir, filename )
      end
    end

    protected

    def generate_track( track, output_path )
      FileUtils.mkdir_p output_path

      input = track.file.current_path
      output = File.join( output_path, track_file_basename( track ) )

      generator = ::Releaser::Generator.new( input )
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
      tag = ::Releaser::Tag.new
      tag.artist = track.artist.name
      tag.album = track.album.title
      tag.year = track.album.year
      tag.title = track.title
      tag.track = track.rank
      tag.comment = track.comment unless track.comment.blank?

      tag.contact_url = self.release_url
      tag.organization_name = self.publisher.name
      tag.organization_url = self.publisher.url
      tag.license_name = track.license.name if track.license
      tag
    end
  end
end

