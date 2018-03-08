# frozen_string_literal: true

class Settings
  class << self
    attr_writer :filer_root

    def filer_root
      @filer_root || File.join(Rails.root, 'db', 'ftp')
    end

    def filer
      Uploader::Filer.new(filer_root)
    end
  end
end
