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

  def test_get_drafts_for_user_displays_drafts
    login_user
    albums = 3.times.to_a.map do
      Album.sham!(published: false)
    end
    get :drafts

    albums.each do |r|
      assert_select 'a', r.title
    end
  end
end
