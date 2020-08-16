# frozen_string_literal: true

require 'test_helper'

class AlbumReleaserTest < ActiveSupport::TestCase
  def setup
    @artist = Artist.new(name: 'Jęczące Brzękodźwięki', reference: 'jeczace-brzekodzwieki')
    @album = Album.new(
      artist: @artist,
      year: 2020,
      title: 'Tłuczące pokrowce jeżozwierza',
      reference: 'tluczace-pokrowce-jezozwierza',
      image: File.open(File.join(FIXTURES_DIR, 'okladka.jpg'))
    )
    3.times do |i|
      @album.tracks.new(
        file: File.open(File.join(FIXTURES_DIR, 'tracks', "#{i + 1}.wav")),
        title: "Hit numer #{i + 1}",
        rank: i + 1
      )
    end

    @album.attachments.new(file: File.open(File.join(FIXTURES_DIR, 'attachments', 'att1.jpg')))
    @album.attachments.new(file: File.open(File.join(FIXTURES_DIR, 'attachments', 'att2.pdf')))
    @album.attachments.new(file: File.open(File.join(FIXTURES_DIR, 'attachments', 'att3.txt')))
  end

  def test_creates_ogg_release
    releaser = Releaser::AlbumReleaser.new(@album, publisher: Publisher.instance)
    releaser.with_release(Release::OGG) do |file_path|
      check_album_release(@album, Release::OGG, file_path)
    end
  end

  def test_creates_flac_release
    releaser = Releaser::AlbumReleaser.new(@album, publisher: Publisher.instance)
    releaser.with_release(Release::FLAC) do |file_path|
      check_album_release(@album, Release::FLAC, file_path)
    end
  end

  def test_creates_mp3_release
    releaser = Releaser::AlbumReleaser.new(@album, publisher: Publisher.instance)
    releaser.with_release(Release::MP3) do |file_path|
      check_album_release(@album, Release::MP3, file_path)
    end
  end

  def expected_release_url(album)
    "#{Publisher.instance.url}/#{album.artist.reference}/wydawnictwa/#{album.reference}"
  end

  def check_album_release(album, format, file_path)
    artist_reference = album.artist.reference
    album_reference = album.reference

    assert File.exist?(file_path)
    assert_equal "#{artist_reference}-#{album_reference}-#{format}.zip", File.basename(file_path)

    Dir.mktmpdir do |tmp_dir|
      system "unzip #{file_path} -d #{tmp_dir}"

      album_path = File.join(tmp_dir, artist_reference, album_reference)
      assert File.exist? album_path

      assert File.exist? File.join(album_path, 'att1.jpg')
      assert File.exist? File.join(album_path, 'att2.pdf')
      assert File.exist? File.join(album_path, 'att3.txt')
      album.tracks.each do |track|
        track_reference = track.title.parameterize(separator: '_')

        filename = "#{format('%02d', track.rank)}-#{track_reference}.#{format}"
        track_path = File.join(album_path, filename)
        assert File.exist? track_path

        # FIXME
        # type = case release.format
        #   when Release::OGG then 'Ogg'
        #   when Release::MP3 then 'MPEG'
        #   when Release::FLAC then 'FLAC'
        # end
        # assert `file #{track_path}` =~ /#{type}/
      end

      (Release::FORMATS - [format]).each do |format|
        refute File.exist? File.join(album_path, "*.#{format}")
      end
    end
  end
end
