require 'test_helper'

# Tests for artist resource.
class ArtistResourceTest < ActiveSupport::TestCase
  def test_show_is_authorized
    artist = Artist.sham!
    assert_authorization :read, artist do |abilities|
      resourcer({ id: artist.to_param }, abilities).show
    end
  end

  def test_show_returns_artist_with_provided_id
    artist = Artist.sham!
    with_permission_to :read, artist do |abilities|
      result = resourcer({ id: artist.to_param }, abilities).show
      assert_equal artist, result
    end
  end

  def test_new_is_authorized
    assert_authorization :write, Artist do |abilities|
      resourcer({}, abilities).new
    end
  end

  def test_new_returns_new_object
    with_permission_to :write, Artist do |abilities|
      result = resourcer({}, abilities).new
      assert result.is_a? Artist
      refute result.persisted?
    end
  end

  def test_edit_is_authorized
    artist = Artist.sham!
    assert_authorization :write, artist do |abilities|
      resourcer({ id: artist.to_param }, abilities).edit
    end
  end

  def test_edit_returns_artist_with_provided_id
    artist = Artist.sham!
    with_permission_to :write, artist do |abilities|
      result = resourcer({ id: artist.to_param }, abilities).edit
      assert_equal artist, result
    end
  end

  def test_create_is_authorized
    artist = Artist.sham!(:build)
    assert_authorization :write, Artist do |abilities|
      resourcer({ artist: artist.attributes }, abilities).create
    end
  end

  def test_create_creates_artist
    attributes = Artist.sham!(:build).attributes
    artists_count = Artist.count
    with_permission_to :write, Artist do |abilities|
      resourcer({ artist: attributes }, abilities).create
    end
    assert_equal artists_count + 1, Artist.count
  end

  def test_create_raises_exception_for_invalid_attributes
    artists_count = Artist.count
    with_permission_to :write, Artist do |abilities|
      assert_raises Resource::InvalidResource do
        resourcer({ artist: { dummy: 1 } }, abilities).create
      end
    end
    assert_equal artists_count, Artist.count
  end

  def test_update_is_authorized
    artist = Artist.sham!
    assert_authorization :write, artist do |abilities|
      resourcer({ id: artist.to_param, artist: { dummy: 1 } }, abilities).update
    end
  end

  def test_update_updates_artist
    artist = Artist.sham!
    name = Faker::Name.name
    artists_count = Artist.count
    result = with_permission_to :write, artist do |abilities|
      params = { id: artist.to_param, artist: { name: name } }
      resourcer(params, abilities).update
    end
    assert_equal name, result.name
    assert_equal artists_count, Artist.count
  end

  def test_update_raises_exception_for_invalid_attributes
    artist = Artist.sham!
    with_permission_to :write, Artist do |abilities|
      assert_raises Resource::InvalidResource do
        params = { id: artist.to_param, artist: { name: '' } }
        resourcer(params, abilities).update
      end
    end
  end

  def resourcer(params, abilities)
    Resource::ArtistResource.new(params, abilities)
  end
end
