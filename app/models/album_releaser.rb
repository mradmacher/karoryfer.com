class AlbumReleaser < Releaser::Base

  def ogg_quality
    6
  end

  def mp3_quality
    1
  end

  def initialize( album, format )
    @album = album
    @format = format
  end

  def cover_basename
    'okladka'
  end

  def release_url
    unless @album.nil?
      Rails.application.routes.url_helpers.artist_album_url( @album.artist, @album, :host => self.publisher_host )
    end
  end

  def generate
    Dir.mktmpdir do |working_dir|
      album_dir = File.join( @album.artist.reference, @album.reference )
      output_dir = File.join( working_dir, album_dir )

      generate_files( output_dir )

      copy_cover( output_dir )

      copy_attachments( output_dir )

      archive_name = "#{@album.artist.reference}-#{@album.reference}-#{@format}.zip"
      make_archive( working_dir, archive_name )

      yield File.join( working_dir, archive_name )
    end
  end

  private

  def generate_files( output_dir )
    @album.tracks.each do |track|
      generate_track( track, output_dir )
    end
  end

  def copy_cover( output_dir )
    if @album.image.path
      FileUtils.cp( @album.image.path, File.join( output_dir, "#{self.cover_basename}#{File.extname( @album.image.path )}" ) )
    end
  end

  def copy_attachments( output_dir )
    @album.attachments.each do |attachment|
      FileUtils.cp( attachment.file.current_path, output_dir )
    end
  end

  def make_archive( working_dir, archive_name )
    pwd = Dir.pwd
    Dir.chdir working_dir
    system "zip -rm #{archive_name} *"
    Dir.chdir pwd
  end

  def track_file_basename( track )
    "#{sprintf( '%02d', track.rank )}-#{underscore(track.title)}"
  end

end

