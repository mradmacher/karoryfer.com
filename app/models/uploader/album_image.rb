# frozen_string_literal: true

module Uploader
  class AlbumImage < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick
    process resize_to_limit: [800, 800]

    def filename
      "#{base_filename}.#{file.extension}" if original_filename
    end

    version :icon do
      process resize_to_limit: [110, 110]
      process convert: 'png'

      def full_filename(_something)
        "#{base_filename}_icon.png"
      end
    end

    version :thumb do
      process resize_to_limit: [300, 400]
      process convert: 'png'

      def full_filename(_something)
        "#{base_filename}_thumb.png"
      end
    end

    def store_dir
      File.join(Rails.root, 'public', 'uploads', 'obrazki', 'wydawnictwa')
    end

    def extension_whitelist
      %w[jpg jpeg png gif]
    end

    private

    def base_filename
      "#{model.artist.reference}_#{model.reference}"
    end
  end
end
