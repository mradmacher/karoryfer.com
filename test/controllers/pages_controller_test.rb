# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  def test_get_index_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :index
    end
  end

  def test_get_show_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :show, params: { id: Page.sham!.to_param }
    end
  end

  def test_get_show_succeeds
    page = Page.sham!
    get :show, params: { artist_id: page.artist.to_param, id: page.to_param }
    assert_response :success
  end
end
