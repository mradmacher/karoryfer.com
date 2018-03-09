# frozen_string_literal: true

require 'test_helper'

class AlbumPolicyTest < ActiveSupport::TestCase
  def test_accessing_published_album_resources_as_guest_is_allowed
    album = Album.sham!(:published)
    user = User.new
    assert AlbumPolicy.new(user).read?(album)
    assert AttachmentPolicy.new(user).read?(Attachment.new(album: album))
    assert TrackPolicy.new(user).read?(Track.new(album: album))
    assert ReleasePolicy.new(user).read?(Release.new(album: album))
  end

  def test_accessing_unpublished_album_resources_as_guest_is_denied
    album = Album.sham!(:unpublished)
    user = User.new
    refute AlbumPolicy.new(user).read?(album)
    refute AttachmentPolicy.new(user).read?(Attachment.new(album: album))
    refute TrackPolicy.new(user).read?(Track.new(album: album))
    refute ReleasePolicy.new(user).read?(Release.new(album: album))
  end

  def test_managing_published_album_resources_as_guest_is_denied
    album = Album.sham!(:published)
    user = User.new
    refute AlbumPolicy.new(user).write?(album)
    refute AttachmentPolicy.new(user).write?(Attachment.new(album: album))
    refute TrackPolicy.new(user).write?(Track.new(album: album))
    refute ReleasePolicy.new(user).write?(Release.new(album: album))
  end

  def test_accessing_unpublished_artist_account_album_resources_is_allowed
    user = login_user
    album = Album.sham!(:unpublished)
    assert AlbumPolicy.new(user).read?(album)
    assert AttachmentPolicy.new(user).read?(Attachment.new(album: album))
    assert TrackPolicy.new(user).read?(Track.new(album: album))
    assert ReleasePolicy.new(user).read?(Release.new(album: album))
  end

  def test_managing_account_album_resources_is_denied
    user = login_user
    album = Album.sham!
    refute AlbumPolicy.new(user).write?(album)
    refute AttachmentPolicy.new(user).write?(Attachment.new(album: album))
    refute TrackPolicy.new(user).write?(Track.new(album: album))
    refute ReleasePolicy.new(user).write?(Release.new(album: album))
  end

  def test_managing_account_album_resources_as_publisher_is_allowed
    user = login_user
    user.update_attributes(publisher: true)
    album = Album.sham!
    assert AlbumPolicy.new(user).write?(album)
    assert AttachmentPolicy.new(user).write?(Attachment.new(album: album))
    assert TrackPolicy.new(user).write?(Track.new(album: album))
    assert ReleasePolicy.new(user).write?(Release.new(album: album))
  end

  def test_visitor_has_read_but_not_write_access
    policy = AlbumPolicy.new(User.new)
    assert policy.read_access?
    refute policy.write_access?
  end

  def test_member_has_read_but_not_write_access
    policy = AlbumPolicy.new(User.sham!)
    assert policy.read_access?
    refute policy.write_access?
  end

  def test_publisher_has_read_and_write_access
    policy = AlbumPolicy.new(User.sham!(publisher: true, admin: false))
    assert policy.read_access?
    assert policy.write_access?
  end

  def test_admin_has_read_but_not_write_access
    policy = AlbumPolicy.new(User.sham!(publisher: false, admin: true))
    assert policy.read_access?
    refute policy.write_access?
  end
end
