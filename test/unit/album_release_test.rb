# encoding: utf-8
# frozen_string_literal: true

require 'test_helper'

class AlbumReleaseTest < ActiveSupport::TestCase
  def setup
    @tmp_dir = Dir.mktmpdir
    Uploader::Release.store_dir = @tmp_dir

    @artist = Artist.sham! name: 'Jęczące Brzękodźwięki'
    @album = Album.sham!(
      title: 'Tłuczące pokrowce jeżozwierza',
      image: File.open(File.join(FIXTURES_DIR, 'okladka.jpg'))
    )
    3.times do |i|
      Track.sham!(
        album: @album,
        file: File.open(File.join(FIXTURES_DIR, 'tracks', "#{i + 1}.wav"))
      )
    end
    @album.tracks.each do |track|
      puts track.file
    end

    @album.attachments.create(file: File.open(File.join(FIXTURES_DIR, 'attachments', 'att1.jpg')))
    @album.attachments.create(file: File.open(File.join(FIXTURES_DIR, 'attachments', 'att2.pdf')))
    @album.attachments.create(file: File.open(File.join(FIXTURES_DIR, 'attachments', 'att3.txt')))
  end

  def teardown
    FileUtils.remove_entry_secure @tmp_dir
  end

  def test_creates_ogg_release
    release = Release.create(album: @album, format: Release::OGG)
    release.generate!
    check_album_release release
  end

  def test_creates_flac_release
    release = Release.create(album: @album, format: Release::FLAC)
    release.generate!
    check_album_release release
  end

  def test_creates_mp3_release
    release = Release.create(album: @album, format: Release::MP3)
    release.generate!
    check_album_release release
  end

  def test_creates_releases_with_overriden_tags
    @album.tracks.each { |t| t.artist_name = 'Some artist' }
    [Release::OGG, Release::FLAC, Release::MP3].each do |format|
      release = Release.create(album: @album, format: format)
      release.generate!
      check_album_release release
    end
  end

  def expected_release_url(album)
    "#{Publisher.instance.url}/#{album.artist.reference}/wydawnictwa/#{album.reference}"
  end

  def check_album_release(release)
    album = release.album
    artist_reference = album.artist.reference
    album_reference = album.reference
    file_path = release.file.path

    assert File.exist?(file_path)
    assert_equal "#{artist_reference}-#{album_reference}-#{release.format}.zip", File.basename(file_path)

    Dir.mktmpdir do |tmp_dir|
      system "unzip #{file_path} -d #{tmp_dir}"

      album_path = File.join(tmp_dir, artist_reference, album_reference)
      assert File.exist? album_path

      assert File.exist? File.join(album_path, 'att1.jpg')
      assert File.exist? File.join(album_path, 'att2.pdf')
      assert File.exist? File.join(album_path, 'att3.txt')
      album.tracks.each do |track|
        track_reference = track.title.parameterize('_')

        filename = "#{format('%02d', track.rank)}-#{track_reference}.#{release.format}"
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

      (Release::FORMATS - [release.format]).each do |format|
        refute File.exist? File.join(album_path, "*.#{format}")
      end
    end
  end
end
