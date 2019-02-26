# frozen_string_literal: true

module Uploader
  class EventImage < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick
    cattr_accessor :store_dir

    def extension_white_list
      %w[jpg jpeg png gif]
    end

    process resize_to_limit: [1200, 1200]

    def filename
      return unless original_filename

      if model && model.read_attribute(mounted_as).present?
        model.read_attribute(mounted_as)
      else
        "#{secure_token}.#{file.extension}"
      end
    end

    version :icon do
      process resize_to_limit: [180, 180]
      process convert: 'png'

      def full_filename(for_file)
        "#{version_file_basename(for_file)}_icon.png"
      end
    end

    version :thumb do
      process resize_to_limit: [300, 400]
      process convert: 'png'

      def full_filename(for_file)
        "#{version_file_basename(for_file)}_thumb.png"
      end
    end

    def store_dir
      File.join(@@store_dir, (model.id / 100).to_s)
    end

    protected

    def version_file_basename(for_file)
      File.basename(for_file, File.extname(for_file))
    end

    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
    end
  end
end
