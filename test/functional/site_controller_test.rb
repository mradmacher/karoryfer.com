require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  def test_get_artists_succeeds
    3.times { Artist.sham! }
    get :artists
    assert_response :success
  end

  def test_get_artists_displays_headers
    get :artists
    assert_select 'title', build_title(I18n.t('title.artist.index'))
    assert_select 'h1', I18n.t('title.artist.index')
  end

  def test_get_artists_does_not_display_actions_when_not_authorized
    deny(:write, :artist)
    get :artists
    assert_select 'a[href=?]', new_artist_path, 0
  end

  def test_get_artists_displays_actions_when_authorized
    allow(:write, :artist)
    get :artists
    assert_select 'a[href=?]', new_artist_path
  end

  def test_get_home_succeeds
    3.times { Artist.sham! }
    3.times { Album.sham! }
    3.times { Event.sham! }
    3.times { Post.sham! }
    3.times { Video.sham! }
    get :home
    assert_response :success
  end

  def test_get_albums_succeeds
    3.times { Album.sham! }
    get :albums
    assert_response :success
  end

  def test_get_drafts_for_guest_is_denied
    assert_raises User::AccessDenied do
      get :drafts
    end
  end

  def test_get_drafts_for_user_displays_nothing
    login_user
    albums = 3.times.to_a.map { Album.sham!(published: false) }
    get :drafts

    albums.each do |r|
      assert_select 'a', text: r.title, count: 0
    end
  end

  def test_get_drafts_for_artist_user_displays_drafts
    membership = login_artist_user
    albums = 3.times.to_a.map do
      Album.sham!(published: false, artist: membership.artist)
    end
    get :drafts

    albums.each do |r|
      assert_select 'a', r.title
    end
  end

  def test_get_drafts_for_artist_user_display_unpublished_albums_only_for_this_user
    membership = login_artist_user
    artist = membership.artist
    for_artist = []
    not_for_artist = []
    5.times { for_artist << Album.sham!(:unpublished, artist: artist) }
    5.times { not_for_artist << Album.sham!(:unpublished) }
    get :drafts
    for_artist.each do |a|
      assert_select 'a', a.title
    end
    not_for_artist.each do |a|
      assert_select '*', text: a.title, count: 0
    end
  end
end
