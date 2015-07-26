module Ability::ForGuest
  def test_accessing_artist_resources_is_allowed
    assert @ability.allows?(:read, :artist)
    assert @ability.allows?(:read, @artist)
    assert @ability.allows?(:read_post, @artist)
    assert @ability.allows?(:read_event, @artist)
    assert @ability.allows?(:read_video, @artist)
    assert @ability.allows?(:read_page, @artist)
  end

  def test_managing_artist_resources_is_denied
    refute @ability.allows?(:write, @artist)
    refute @ability.allows?(:write_post, @artist)
    refute @ability.allows?(:write_event, @artist)
    refute @ability.allows?(:write_video, @artist)
    refute @ability.allows?(:write_page, @artist)
  end

  def accessing_published_album_resources_is_allowed
    @album.update_attributes(published: true)
    assert @ability.allows?(:read, :album)
    assert @ability.allows?(:read, @album)
    assert @ability.allows?(:read_attachment, @album)
    assert @ability.allows?(:read_track, @album)
  end

  def test_accessing_unpublished_album_resources_is_denied
    @album.update_attributes(published: false)
    refute @ability.allows?(:read, @album)
    refute @ability.allows?(:read_attachment, @album)
    refute @ability.allows?(:read_track, @album)
  end

  def test_managing_album_resources_is_denied
    refute @ability.allows?(:write, :album)
    refute @ability.allows?(:write, @album)
    refute @ability.allows?(:write_attachment, @album)
    refute @ability.allows?(:write_track, @album)
    refute @ability.allows?(:write_release, @album)
    refute @ability.allows?(:read_release, @album)
  end

  def test_accessing_user_resources_is_denied
    refute @ability.allows?(:read, :user)
    refute @ability.allows?(:read, @user)
    refute @ability.allows?(:read_membership, @user)
  end

  def test_managing_user_resources_is_denied
    refute @ability.allows?(:write, :user)
    refute @ability.allows?(:write, @user)
    refute @ability.allows?(:write_membership, @user)
  end
end
