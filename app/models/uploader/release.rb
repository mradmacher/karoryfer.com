module Uploader
  class Release < CarrierWave::Uploader::Base
    cattr_accessor :album_store_dir, :track_store_dir

    def store_dir
      if model.album
        File.join( @@album_store_dir, model.album.artist.reference )
      else
        File.join( @@track_store_dir, (model.track.id / 1000).to_s )
      end
    end
  end
end

