require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  def test_get_new_succeeds
    get :new
    assert_response :success
  end
end
