require 'test_helper'

class Ability::AdminTest < ActiveSupport::TestCase
  def setup
    @ability = Ability.new(User.sham!(:build, :admin))
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

  def test_write_attachment_is_denied
    attachment = Attachment.sham!(:build)
    refute @ability.allowed?(:write, attachment)
  end

  def test_create_attachment_is_denied
    album = Album.sham!
    refute @ability.allowed?(:write, Attachment)
    refute @ability.allowed?(:write, Attachment, album)
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

  def test_create_artist_is_allowed
    assert @ability.allowed?(:write, Artist)
  end

  def test_read_user_is_allowed
    user = User.sham!
    assert @ability.allowed?(:read, user)
  end

  def test_read_users_is_allowed
    assert @ability.allowed?(:read, User)
  end

  def test_write_user_is_allowed
    user = User.sham!
    assert @ability.allowed?(:read, user)
  end

  def test_create_user_is_allowed
    assert @ability.allowed?(:read, User)
  end

  def test_read_membership_is_allowed
    membership = Membership.sham!
    assert @ability.allowed?(:read, membership)
  end

  def test_write_membership_is_allowed
    membership = Membership.sham!
    assert @ability.allowed?(:write, membership)
  end

  def test_create_membership_is_allowed
    user = User.sham!
    refute @ability.allowed?(:write, Membership)
    assert @ability.allowed?(:write, Membership, user)
  end
end

