module Uploader
  class Filer
    attr_reader :root

    def initialize(root)
      @root = root
    end

    def list(filter = '*')
      Dir.glob(File.join(root, '**', filter)).
        reject{ |e| Dir.exist?(e) }.
        map{ |e| e.sub!(/^#{root}\//, '') }
    end

    def path_to(file)
      File.join(root, file) if list.include?(file)
    end
  end
end
