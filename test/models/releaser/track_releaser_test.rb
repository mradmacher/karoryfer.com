# frozen_string_literal: true

require 'test_helper'

class TrackReleaserTest < ActiveSupport::TestCase
  def setup
    @artist = Artist.new(name: 'Jęczące Brzękodźwięki', reference: 'jeczace-brzekodzwieki')
    @album = Album.new(title: 'Zagrajmy to razem', artist: @artist, reference: 'zagrajmy-to-razem')
    @track = Track.new(file: File.open(File.join(FIXTURES_DIR, 'tracks', '1.wav')), album: @album)
  end

  def test_creates_ogg_preview
    releaser = Releaser::TrackReleaser.new(@track, publisher: Publisher.instance)
    releaser.with_release(Release::OGG) do |file_path|
      assert File.exist? file_path
      assert_equal "#{@track.id}.ogg", File.basename(file_path)
      assert `file #{file_path}` =~ /Ogg/
    end
  end

  def test_creates_mp3_preview
    releaser = Releaser::TrackReleaser.new(@track, publisher: Publisher.instance)
    releaser.with_release(Release::MP3) do |file_path|
      assert File.exist? file_path
      assert_equal "#{@track.id}.mp3", File.basename(file_path)
      assert `file #{file_path}` =~ /MPEG/
    end
  end

  def expected_release_url(track)
    "#{Publisher.instance.url}/#{track.artist.reference}/wydawnictwa/#{track.album.reference}"
  end
end

