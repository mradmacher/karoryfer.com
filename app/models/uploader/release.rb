# frozen_string_literal: true

module Uploader
  class Release < CarrierWave::Uploader::Base
    def store_dir
      File.join(Rails.root, 'downloads', 'releases', model.album.artist.reference)
    end

    def filename
      return unless original_filename

      suffix = file.extension == model.format ? '' : "-#{model.format}"
      "#{model.album.artist.reference}-#{model.album.reference}#{suffix}.#{file.extension}"
    end
  end
end
