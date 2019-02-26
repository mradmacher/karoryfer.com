# frozen_string_literal: true

require 'test_helper'

class TrackReleaseTest < ActiveSupport::TestCase
  def setup
    @tmp_dir = Dir.mktmpdir
    Uploader::TrackPreview.store_dir = @tmp_dir
    @artist = Artist.sham! name: 'Jęczące Brzękodźwięki'
    @track = Track.sham! file: File.open(File.join(FIXTURES_DIR, 'tracks', '1.wav'))
  end

  def teardown
    FileUtils.remove_entry_secure @tmp_dir
  end

  def test_creates_ogg_and_mp3_preview
    @track.generate_preview!

    assert @track.ogg_preview?
    assert @track.mp3_preview?
    ogg_file_path = @track.ogg_preview.path
    mp3_file_path = @track.mp3_preview.path

    assert File.exist? ogg_file_path
    assert_equal "#{@track.id}.ogg", File.basename(ogg_file_path)
    assert `file #{ogg_file_path}` =~ /Ogg/
    assert File.exist? mp3_file_path
    assert_equal "#{@track.id}.mp3", File.basename(mp3_file_path)
    assert `file #{mp3_file_path}` =~ /MPEG/
  end

  def expected_release_url(track)
    "#{Publisher.instance.url}/#{track.artist.reference}/wydawnictwa/#{track.album.reference}"
  end
end
