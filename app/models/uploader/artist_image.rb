module Uploader
  class ArtistImage < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick
    cattr_accessor :store_dir

    process resize_to_limit: [800, 800]

    def filename
      "#{model.reference}.#{file.extension}" if original_filename
    end

    version :icon do
      process resize_to_limit: [110, 110]
      process convert: 'png'

      def full_filename(for_file)
        "#{model.reference}_icon.png"
      end
    end

    version :thumb do
      process resize_to_limit: [300, 400]
      process convert: 'png'

      def full_filename(for_file)
        "#{model.reference}_thumb.png"
      end
    end

    def store_dir
      @@store_dir
    end

    def extension_white_list
      %w(jpg jpeg png gif)
    end
  end
end
