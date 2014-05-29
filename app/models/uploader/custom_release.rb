module Uploader
  class CustomRelease < CarrierWave::Uploader::Base
    cattr_accessor :store_dir

    def store_dir
      File.join( @@store_dir, model.artist.reference )
    end

    def filename
      "#{model.artist.reference}-#{model.reference}.#{file.extension}" if original_filename
    end

    def extension_white_list
      %w(zip)
    end
  end
end

