require 'test_helper'

class Ability::AdminTest < ActiveSupport::TestCase
  def setup
    @ability = Ability.new(User.sham!(:build, :admin))
  end

  def test_write_album_is_allowed
    album = Album.sham!(:build)
    assert @ability.allowed?(:write, album)
  end

  def test_create_album_is_allowed
    artist = Artist.sham!
    refute @ability.allowed?(:write, Album)
    assert @ability.allowed?(:write, Album, artist)
  end

  def test_write_attachment_is_allowed
    attachment = Attachment.sham!(:build)
    assert @ability.allowed?(:write, attachment)
  end

  def test_create_attachment_is_allowed
    album = Album.sham!
    refute @ability.allowed?(:write, Attachment)
    assert @ability.allowed?(:write, Attachment, album)
  end

  def test_write_track_is_allowed
    track = Track.sham!(:build)
    assert @ability.allowed?(:write, track)
  end

  def test_create_track_is_allowed
    album = Album.sham!
    refute @ability.allowed?(:write, Track)
    assert @ability.allowed?(:write, Track, album)
  end

  def test_create_artist_is_allowed
    assert @ability.allowed?(:write, Artist)
  end

  def test_read_account_is_allowed
    user = User.sham!
    assert @ability.allowed?(:read, user)
  end

  def test_write_account_is_allowed
    user = User.sham!
    assert @ability.allowed?(:read, user)
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

