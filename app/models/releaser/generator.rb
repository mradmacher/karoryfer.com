module Releaser
  class Generator
    attr_accessor :input

    def initialize(input)
      @input = input
    end

    def gen_ogg(output, quality)
      system "oggenc #{@input} -q #{quality} -o #{output}.ogg"
    end

    def gen_mp3(output, quality)
      system "lame -V #{quality} #{@input} #{output}.mp3"
    end

    def gen_flac(output)
      system "flac #{@input} -o #{output}.flac"
    end
  end
end
