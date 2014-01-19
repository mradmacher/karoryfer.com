require 'test_helper'

class ReleaseDBTest < ActiveSupport::TestCase
  def setup
    @artist_id = DB[:artists].insert( name: Faker::Name.name, reference: Faker::Name.name.parameterize )
    @album_id = DB[:albums].insert( title: Faker::Name.name, reference: Faker::Name.name.parameterize,
      artist_id: @artist_id, year: 2013 )
  end

  def teardown
    DB[:releases].truncate
  end

  def test_complains_about_duplicated_format_for_same_album
    DB[:releases].insert( album_id: @album_id, file: 'somefile.flac', format: 'flac' )
    exception = assert_raises Sequel::UniqueConstraintViolation do
      DB[:releases].insert( album_id: @album_id, file: 'otherfile.flac', format: 'flac' )
    end
    assert_match( /releases_album_format_key/, exception.message )
  end

  def test_does_not_complains_about_duplicated_formats_for_different_albums
    other_album_id = DB[:albums].insert( title: Faker::Name.name, reference: Faker::Name.name.parameterize,
      artist_id: @artist_id, year: 2013 )
    DB[:releases].insert( album_id: @album_id, file: 'somefile.flac', format: 'flac' )
    assert_nothing_raised do
      DB[:releases].insert( album_id: other_album_id, file: 'somefile.flac', format: 'flac' )
    end
  end

  def test_complains_about_duplicated_format_for_same_track
    track_id = DB[:tracks].insert( rank: 1, title: Faker::Name.name, album_id: @album_id )
    DB[:releases].insert( track_id: track_id, file: 'somefile.flac', format: 'flac' )
    exception = assert_raises Sequel::UniqueConstraintViolation do
      DB[:releases].insert( track_id: track_id, file: 'otherfile.flac', format: 'flac' )
    end
    assert_match( /releases_track_format_key/, exception.message )
  end

  def test_does_not_complains_about_duplicated_formats_for_different_tracks
    track_id = DB[:tracks].insert( rank: 1, title: Faker::Name.name, album_id: @album_id )
    other_track_id = DB[:tracks].insert( rank: 1, title: Faker::Name.name, album_id: @album_id )
    DB[:releases].insert( track_id: track_id, file: 'somefile.flac', format: 'flac' )
    assert_nothing_raised do
      DB[:releases].insert( track_id: other_track_id, file: 'otherfile.flac', format: 'flac' )
    end
  end

  def test_does_not_complains_about_duplicated_formats_for_track_and_album
    track_id = DB[:tracks].insert( rank: 1, title: Faker::Name.name, album_id: @album_id )
    other_track_id = DB[:tracks].insert( rank: 1, title: Faker::Name.name, album_id: @album_id )
    other_album_id = DB[:albums].insert( title: Faker::Name.name, reference: Faker::Name.name.parameterize,
      artist_id: @artist_id, year: 2013 )
    assert_nothing_raised do
      DB[:releases].insert( track_id: track_id, file: 'somefile', format: 'flac' )
      DB[:releases].insert( track_id: other_track_id, file: 'somefile', format: 'flac' )
      DB[:releases].insert( album_id: @album_id, file: 'somefile', format: 'flac' )
      DB[:releases].insert( album_id: other_album_id, file: 'somefile', format: 'flac' )
    end
  end
end

