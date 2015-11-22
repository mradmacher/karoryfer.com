module Uploader
  class Release < CarrierWave::Uploader::Base
    cattr_accessor :store_dir

    def store_dir
      File.join(@@store_dir, model.album.artist.reference)
    end

    def filename
      if original_filename
        suffix = (file.extension == model.format) ? '' : "-#{model.format}"
        "#{model.album.artist.reference}-#{model.album.reference}#{suffix}.#{file.extension}"
      end
    end
  end
end
