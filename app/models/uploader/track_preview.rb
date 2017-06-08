module Uploader
  class TrackPreview < CarrierWave::Uploader::Base
    def store_dir
      File.join(Rails.root, 'public', 'downloads', 'tracks', (model.id / 100).to_s)
    end

    def filename
      "#{model.id}.#{file.extension}" if original_filename
    end
  end
end

