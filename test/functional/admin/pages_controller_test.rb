# frozen_string_literal: true

require 'test_helper'

class Admin::PagesControllerTest < ActionController::TestCase
  def test_delete_destroy_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      delete :destroy, id: Page.sham!.to_param
    end
  end

  def test_get_edit_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :edit, id: Page.sham!.to_param
    end
  end

  def test_get_new_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :new
    end
  end

  def test_post_create_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      post :create, page: {}
    end
  end

  def test_put_update_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      put :update, id: Page.sham!.id, page: {}
    end
  end

  def test_delete_destroy_succeeds
    login_user
    page = Page.sham!
    assert_equal 1, Page.count
    delete :destroy, artist_id: page.artist.to_param, id: page.to_param
    assert_redirected_to artist_path(page.artist)
    assert_equal 0, Page.count
  end
end
