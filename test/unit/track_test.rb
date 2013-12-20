require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  FIXTURES_DIR = File.expand_path('../../fixtures/tracks', __FILE__)

  def test_validates_title_presence
    track = Track.sham! :build
    [nil, '', ' ', '   '].each do |title|
      track.title = title
      refute track.valid?
      assert track.errors[:title].include? I18n.t(
        'activerecord.errors.models.track.attributes.title.blank' )
    end
  end

  def test_validates_title_length
    track = Track.sham! :build
    track.title = 'a' * (Track::TITLE_MAX_LENGTH+1)
    refute track.valid?
    assert track.errors[:title].include? I18n.t(
      'activerecord.errors.models.track.attributes.title.too_long' )

    track.title = 'a' * Track::TITLE_MAX_LENGTH
    assert track.valid?
  end

  def test_validates_album_presence
    track = Track.sham! :build
    track.album_id = nil
    refute track.valid?
    assert track.errors[:album_id].include? I18n.t(
      'activerecord.errors.models.track.attributes.album_id.blank' )
  end

  def test_validates_rank_presence
    track = Track.sham! :build
    track.rank = nil
    refute track.valid?
    assert track.errors[:rank].include? I18n.t(
      'activerecord.errors.models.track.attributes.rank.blank' )
  end

  def test_validates_rank_uniqueness_for_album
    existing_track = Track.sham!
    track = Track.sham! :build, album: existing_track.album
    track.rank = existing_track.rank
    refute track.valid?
    assert track.errors[:rank].include? I18n.t(
      'activerecord.errors.models.track.attributes.rank.taken' )
  end

  def test_allows_repeating_ranks_in_different_albums
    existing_track = Track.sham!
    track = Track.sham! :build, album: Album.sham!
    track.rank = existing_track.rank
    assert track.valid?
  end

  def test_allows_blank_comments
    track = Track.sham! :build
    track.comment = nil
    assert track.valid?

    track.comment = ''
    assert track.valid?
  end

  def test_validates_comment_length
    track = Track.sham! :build
    track.comment = 'a' * (Track::COMMENT_MAX_LENGTH+1)
    refute track.valid?
    assert track.errors[:comment].include? I18n.t(
      'activerecord.errors.models.track.attributes.comment.too_long' )

    track.comment = 'a' * Track::COMMENT_MAX_LENGTH
    assert track.valid?
  end

  def test_default_scope_orders_tracks_by_rank
    album = Album.sham!
    5.times { Track.sham! album: album }
    album_tracks = album.tracks
    i = 0
    album_tracks.each do |track|
      assert i < track.rank
      i = track.rank
    end
  end

  def test_allows_nil_file
    track = Track.sham! :build, file: nil
    assert track.valid?
  end

  def test_accepts_only_wav_files
    ['att1.jpg', 'att2.pdf', 'att3.txt'].each do |filename|
      file_path = File.join( FIXTURES_DIR, '..', 'attachments', filename )
      track = Track.sham! :build, file: File.open( file_path )
      refute track.valid?
      refute track.errors[ :file ].empty?
    end
    file_path = File.join( FIXTURES_DIR, '1.wav' )
    track = Track.sham! :build, file: File.open( file_path )
    assert track.valid?
  end

  def test_on_save_places_file_in_proper_dir
    track = Track.sham! file: File.open( File.join( FIXTURES_DIR, '1.wav' ) )
    filename = track.file.identifier
    track = Track.find track.id
    file_path = File.join( Track::Uploader.store_dir, (track.id / 1000).to_s, "#{File.basename(filename, '.wav')}.wav" )
    assert_equal file_path, track.file.current_path
    assert File.exists? file_path
  end

  def test_on_save_replaces_old_file_with_new_one
    track = Track.sham! file: File.open( File.join( FIXTURES_DIR, '1.wav' ) )
    old_file_path = track.file.current_path
    assert File.exists? old_file_path

    track.file = File.open( File.join( FIXTURES_DIR, '2.wav' ) )
    track.save
    assert_equal old_file_path, track.file.current_path
    assert File.exists? old_file_path
  end

  def test_on_destroy_removes_file_from_storage
    track = Track.sham! file: File.open( File.join( FIXTURES_DIR, '1.wav' ) )
    file_path = track.file.current_path
    assert File.exists? file_path

    track.destroy
    refute File.exists? file_path
  end
end

