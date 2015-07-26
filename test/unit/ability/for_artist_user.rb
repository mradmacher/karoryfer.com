module Ability::ForArtistUser
  def test_managing_account_artist_resources_is_allowed
    assert @ability.allows?(:write, @account_artist)
    assert @ability.allows?(:write_post, @account_artist)
    assert @ability.allows?(:write_event, @account_artist)
    assert @ability.allows?(:write_video, @account_artist)
    assert @ability.allows?(:write_page, @account_artist)
  end

  def test_accessing_unpublished_artist_account_album_resources_is_allowed
    @account_album.update_attributes(published: false)
    assert @ability.allows?(:read, @account_album)
    assert @ability.allows?(:read_attachment, @account_album)
    assert @ability.allows?(:read_track, @account_album)
  end

  def test_managing_account_album_resources_is_denied
    refute @ability.allows?(:write, @account_album)
    refute @ability.allows?(:write_attachment, @account_album)
    refute @ability.allows?(:write_track, @account_album)
    refute @ability.allows?(:write_release, @account_album)
    refute @ability.allows?(:read_release, @account_album)
  end

  def test_managing_account_album_resources_as_publisher_is_allowed
    @account.update_attributes(publisher: true)
    assert @ability.allows?(:write_album, @account_artist)
    assert @ability.allows?(:write, @account_album)
    assert @ability.allows?(:write_attachment, @account_album)
    assert @ability.allows?(:write_track, @account_album)
    assert @ability.allows?(:write_release, @account_album)
    assert @ability.allows?(:read_release, @account_album)
  end

  def test_managing_other_artist_albums_as_publisher_is_denied
    @account.update_attributes(publisher: true)
    refute @ability.allows?(:write_album, @artist)
    refute @ability.allows?(:write, @album)
    refute @ability.allows?(:write_attachment, @album)
    refute @ability.allows?(:write_track, @album)
    refute @ability.allows?(:write_release, @album)
    refute @ability.allows?(:read_release, @album)
  end

  def test_changing_artist_is_allowed
    assert @ability.allows?(:write, @account_artist)
  end
end
