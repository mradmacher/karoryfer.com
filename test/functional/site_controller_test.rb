# frozen_string_literal: true

require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  def test_get_artists_succeeds
    3.times { Artist.sham! }
    get :artists
    assert_response :success
  end

  def test_get_home_succeeds
    3.times { Artist.sham! }
    3.times { Album.sham! }
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
