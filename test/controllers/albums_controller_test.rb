# frozen_string_literal: true

require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  def test_get_index_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :index, params: { id: '1' }
    end
  end

  def test_get_show_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :show, params: { id: 'album' }
    end
  end
end
