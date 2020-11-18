# frozen_string_literal: true

require 'test_helper'

class SiteControllerTest < ActionController::TestCase
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
end
