# frozen_string_literal: true

require 'test_helper'

class Admin::PagesControllerTest < ActionController::TestCase
  def test_delete_destroy_succeeds
    login_user
    page = Page.sham!
    assert_equal 1, Page.count
    delete :destroy, params: { artist_id: page.artist.to_param, id: page.to_param }
    assert_redirected_to artist_path(page.artist)
    assert_equal 0, Page.count
  end
end
