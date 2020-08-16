# frozen_string_literal: true

module Uploader
  class ArtistImage < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick
    process resize_to_limit: [800, 800]

    def filename
      "#{model.reference}.#{file.extension}" if original_filename
    end

    version :icon do
      process resize_to_limit: [110, 110]
      process convert: 'png'

      def full_filename(_something)
        "#{model.reference}_icon.png"
      end
    end

    version :thumb do
      process resize_to_limit: [300, 400]
      process convert: 'png'

      def full_filename(_something)
        "#{model.reference}_thumb.png"
      end
    end

    def store_dir
      File.join(Rails.root, 'public', 'uploads', 'obrazki', 'artysci')
    end

    def extension_whitelist
      %w[jpg jpeg png gif]
    end
  end
end
