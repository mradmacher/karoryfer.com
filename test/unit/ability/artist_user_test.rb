require 'test_helper'

class Ability::ArtistUserTest < ActiveSupport::TestCase
  def setup
    @membership = Membership.sham!
    @ability = Ability.new(@membership.user)
  end

  def test_write_post_is_allowed
    post = Post.sham!(:build, artist: @membership.artist)
    assert @ability.allowed?(:write, post)
  end

  def test_create_post_is_allowed
    refute @ability.allowed?(:write, Post)
    assert @ability.allowed?(:write, Post, @membership.artist)
  end

  def test_write_event_is_allowed
    event = Event.sham!(:build, artist: @membership.artist)
    assert @ability.allowed?(:write, event)
  end

  def test_create_event_is_allowed
    refute @ability.allowed?(:write, Event)
    assert @ability.allowed?(:write, Event, @membership.artist)
  end

  def test_write_video_is_allowed
    video = Video.sham!(:build, artist: @membership.artist)
    assert @ability.allowed?(:write, video)
  end

  def test_create_video_is_allowed
    refute @ability.allowed?(:write, Video)
    assert @ability.allowed?(:write, Video, @membership.artist)
  end

  def test_write_page_is_allowed
    page = Page.sham!(:build, artist: @membership.artist)
    assert @ability.allowed?(:write, page)
    assert @ability.allowed?(:write, Page, @membership.artist)
  end

  def test_create_page_is_allowed
    refute @ability.allowed?(:write, Page)
    assert @ability.allowed?(:write, Page, @membership.artist)
  end

  def test_read_attachment_is_allowed
    album = Album.sham!(:build, artist: @membership.artist)
    attachment = Attachment.sham!(:build, album: album)
    assert @ability.allowed?(:read, attachment)
  end

  def test_read_attachment_from_unpublished_is_allowed
    album = Album.sham!(:build, :unpublished, artist: @membership.artist)
    attachment = Attachment.sham!(:build, album: album)
    assert @ability.allowed?(:read, attachment)
  end

  def test_write_attachment_is_denied
    album = Album.sham!(artist: @membership.artist)
    attachment = Attachment.sham!(:build, album: album)
    refute @ability.allowed?(:write, attachment)
  end

  def test_write_attachment_as_publisher_is_allowed
    @membership.user.publisher = true
    @membership.user.save
    album = Album.sham!(artist: @membership.artist)
    attachment = Attachment.sham!(:build, album: album)
    assert @ability.allowed?(:write, attachment)
  end

  def test_write_attachment_as_publisher_for_other_album_is_denied
    @membership.user.publisher = true
    @membership.user.save
    album = Album.sham!(artist: Artist.sham!)
    attachment = Attachment.sham!(:build, album: album)
    refute @ability.allowed?(:write, attachment)
  end

  def test_create_attachment_is_denied
    album = Album.sham!(artist: @membership.artist)
    refute @ability.allowed?(:write, Attachment)
    refute @ability.allowed?(:write, Attachment, album)
  end

  def test_create_attachment_as_publisher_is_allowed
    @membership.user.publisher = true
    @membership.user.save
    album = Album.sham!(artist: @membership.artist)
    assert @ability.allowed?(:write, Attachment, album)
  end

  def test_create_attachment_as_publisher_for_other_album_is_denied
    @membership.user.publisher = true
    @membership.user.save
    album = Album.sham!(artist: Artist.sham!)
    refute @ability.allowed?(:write, Attachment)
    refute @ability.allowed?(:write, Attachment, album)
  end

  def test_read_track_is_allowed
    album = Album.sham!(:build, artist: @membership.artist)
    track = Track.sham!(:build, album: album)
    assert @ability.allowed?(:read, track)
  end

  def test_read_track_from_unpublished_is_allowed
    album = Album.sham!(:build, :unpublished, artist: @membership.artist)
    track = Track.sham!(:build, album: album)
    assert @ability.allowed?(:read, track)
  end

  def test_write_track_is_denied
    album = Album.sham!(artist: @membership.artist)
    track = Track.sham!(:build, album: album)
    refute @ability.allowed?(:write, track)
  end

  def test_create_track_is_denied
    album = Album.sham!(artist: @membership.artist)
    refute @ability.allowed?(:write, Track)
    refute @ability.allowed?(:write, Track, album)
  end

  def test_write_track_as_publisher_for_other_album_is_denied
    @membership.user.publisher = true
    @membership.user.save
    album = Album.sham!(artist: Artist.sham!)
    track = Track.sham!(:build, album: album)
    refute @ability.allowed?(:write, track)
  end

  def test_create_track_as_publisher_for_other_album_is_denied
    @membership.user.publisher = true
    @membership.user.save
    album = Album.sham!(artist: Artist.sham!)
    refute @ability.allowed?(:write, Track)
    refute @ability.allowed?(:write, Track, album)
  end

  def test_write_track_as_publisher_is_allowed
    @membership.user.publisher = true
    @membership.user.save
    album = Album.sham!(artist: @membership.artist)
    track = Track.sham!(:build, album: album)
    assert @ability.allowed?(:write, track)
  end

  def test_create_track_as_publisher_is_allowed
    @membership.user.publisher = true
    @membership.user.save
    album = Album.sham!(artist: @membership.artist)
    assert @ability.allowed?(:write, Track, album)
  end

  def test_write_artist_is_allowed
    assert @ability.allowed?(:write, @membership.artist)
  end

  def test_create_artist_is_denied
    refute @ability.allowed?(:write, Artist)
  end

  def test_read_album_is_allowed
    album = Album.sham!(:build, artist: @membership.artist)
    assert @ability.allowed?(:read, album)
  end

  def test_read_unpublished_album_is_allowed
    album = Album.sham!(:build, :unpublished, artist: @membership.artist)
    assert @ability.allowed?(:read, album)
  end

  def test_write_album_is_denied
    album = Album.sham!(:build, artist: @membership.artist)
    refute @ability.allowed?(:write, album)
  end

  def test_create_album_is_denied
    refute @ability.allowed?(:write, Album)
    refute @ability.allowed?(:write, Album, @membership.artist)
  end

  def test_write_album_as_publisher_for_other_artist_is_denied
    @membership.user.publisher = true
    @membership.user.save
    album = Album.sham!(:build, artist: Artist.sham!)
    refute @ability.allowed?(:write, album)
  end

  def test_create_album_as_publisher_for_other_artist_is_denied
    @membership.user.publisher = true
    @membership.user.save
    refute @ability.allowed?(:write, Album)
    refute @ability.allowed?(:write, Album, Artist.sham!)
  end

  def test_write_album_as_publisher_is_allowed
    @membership.user.publisher = true
    @membership.user.save
    album = Album.sham!(:build, artist: @membership.artist)
    assert @ability.allowed?(:write, album)
  end

  def test_create_album_as_publisher_is_allowed
    @membership.user.publisher = true
    @membership.user.save
    assert @ability.allowed?(:write, Album, @membership.artist)
  end
end
