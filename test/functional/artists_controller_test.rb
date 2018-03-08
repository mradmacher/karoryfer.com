# frozen_string_literal: true

require 'test_helper'

class ArtistsControllerTest < ActionController::TestCase
  def test_get_show_succeeds
    get :show, id: Artist.sham!.to_param
    assert_template 'current_artist'
    assert_response :success
  end
end
