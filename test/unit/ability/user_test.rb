require 'test_helper'

class Ability::UserTest < ActiveSupport::TestCase
  def setup
    @ability = Ability.new(User.sham!(:build))
  end

  def test_write_post_is_denied
    post = Post.sham!(:build)
    refute @ability.allowed?(:write, post)
  end

  def test_create_post_is_denied
    artist = Artist.sham!
    refute @ability.allowed?(:write, Post)
    refute @ability.allowed?(:write, Post, artist)
  end

  def test_write_event_is_denied
    event = Event.sham!(:build)
    refute @ability.allowed?(:write, event)
  end

  def test_create_event_is_denied
    artist = Artist.sham!
    refute @ability.allowed?(:write, Event)
    refute @ability.allowed?(:write, Event, artist)
  end

  def test_write_video_is_denied
    video = Video.sham!(:build)
    refute @ability.allowed?(:write, video)
  end

  def test_create_video_is_denied
    artist = Artist.sham!
    refute @ability.allowed?(:write, Video)
    refute @ability.allowed?(:write, Video, artist)
  end

  def test_write_page_is_denied
    page = Page.sham!(:build)
    refute @ability.allowed?(:write, page)
    refute @ability.allowed?(:write, Page, Artist.sham!(:build))
  end

  def test_create_page_is_denied
    artist = Artist.sham!
    refute @ability.allowed?(:write, Page)
    refute @ability.allowed?(:write, Page, artist)
  end

  def test_read_attachment_from_unpublished_album_is_denied
    album = Album.sham!(:build, :unpublished)
    attachment = Attachment.sham!(:build, album: album)
    refute @ability.allowed?(:read, attachment)
  end

  def test_write_attachment_is_denied
    attachment = Attachment.sham!(:build)
    refute @ability.allowed?(:write, attachment)
  end

  def test_create_attachment_is_denied
    album = Album.sham!
    refute @ability.allowed?(:write, Attachment)
    refute @ability.allowed?(:write, Attachment, album)
  end

  def test_read_track_from_unpublished_album_is_denied
    album = Album.sham!(:build, :unpublished)
    track = Track.sham!(:build, album: album)
    refute @ability.allowed?(:write, track)
  end

  def test_write_track_is_denied
    track = Track.sham!(:build)
    refute @ability.allowed?(:write, track)
  end

  def test_create_track_is_denied
    album = Album.sham!
    refute @ability.allowed?(:write, Track)
    refute @ability.allowed?(:write, Track, album)
  end

  def test_write_artist_is_denied
    artist = Artist.sham!(:build)
    refute @ability.allowed?(:write, artist)
  end

  def test_create_artist_is_denied
    refute Ability.new(User.sham!(:build)).allowed?(:write, Artist)
  end

  def test_read_unpublished_album_is_denied
    album = Album.sham!(:build, :unpublished)
    refute @ability.allowed?(:read, album)
  end

  def test_write_album_is_denied
    album = Album.sham!(:build)
    refute @ability.allowed?(:write, album)
  end

  def test_create_album_is_denied
    artist = Artist.sham!
    refute @ability.allowed?(:write, Album)
    refute @ability.allowed?(:write, Album, artist)
  end

  def test_read_user_is_denied
    user = User.sham!
    refute @ability.allowed?(:read, user)
  end

  def test_write_user_is_denied
    user = User.sham!
    refute @ability.allowed?(:write, user)
  end

  def test_read_account_is_allowed
    assert @ability.allowed?(:read, @ability.user)
  end

  def test_write_account_is_allowed
    assert @ability.allowed?(:read, @ability.user)
  end

  def test_read_membership_is_denied
    membership = Membership.sham!
    refute @ability.allowed?(:read, membership)
  end

  def test_write_membership_is_denied
    membership = Membership.sham!
    refute @ability.allowed?(:write, membership)
  end

  def test_create_membership_is_denied
    user = User.sham!
    refute @ability.allowed?(:write, Membership)
    refute @ability.allowed?(:write, Membership, user)
  end

  def test_read_membership_for_account_is_allowed
    membership = Membership.sham!(user: @ability.user)
    assert @ability.allowed?(:read, membership)
  end

  def test_write_membership_for_account_is_allowed
    membership = Membership.sham!(user: @ability.user)
    assert @ability.allowed?(:write, membership)
  end

  def test_accessing_release_is_denied
    release = Release.sham!
    refute @ability.allowed?(:read, release)
    refute @ability.allowed?(:write, release)
    refute @ability.allowed?(:write, Release, release.album)
    refute @ability.allowed?(:read, Release, release.album)
  end
end
