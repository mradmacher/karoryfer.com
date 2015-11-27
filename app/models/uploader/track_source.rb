module Uploader
  class TrackSource < CarrierWave::Uploader::Base
    cattr_accessor :store_dir

    def extension_white_list
      %w(wav)
    end

    def filename
      "#{secure_token}.#{file.extension}" if original_filename.present?
    end

    def store_dir
      File.join(@@store_dir, (model.id / 1000).to_s)
    end

    protected

    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
    end
  end
end
