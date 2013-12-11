class TrackReleaser < Releaser::Base
  def ogg_quality
    3
  end

  def mp3_quality
    6
  end

  def initialize( track, format )
    @track = track
    @format = format
  end

  def release_url
    unless @track.nil?
      Rails.application.routes.url_helpers.artist_album_url( @track.artist, @track.album, :host => self.publisher_host )
    end
  end

  def generate
    Dir.mktmpdir do |working_dir|
      output_dir = working_dir

      generate_files( output_dir )
      yield File.join( working_dir, "#{track_file_basename( @track )}.#{@format}" )
    end
  end

  private

  def generate_files( output_dir )
    generate_track( @track, output_dir )
  end

  def track_file_basename( track )
    track.id.to_s
  end

end

