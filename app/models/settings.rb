class Settings
  class << self
    attr_accessor :filer_root

    def values
      @values ||= {}
    end

    def set(key, value)
      values[key] = value
    end

    def get(key)
      values[key]
    end

    def filer
      Uploader::Filer.new(File.join(Rails.root, 'db', 'ftp'))
    end
  end
end
