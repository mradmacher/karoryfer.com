# frozen_string_literal: true

require 'test_helper'
require_relative 'resources_controller'

class PagesControllerTest < ActionController::TestCase
  include ResourcesController

  def resource_name
    'page'
  end

  def resource_class
    Page
  end

  def test_delete_destroy_for_artist_user_properly_redirects
    membership = login_artist_user
    resource = resource_class.sham!(artist: membership.artist)
    delete :destroy, artist_id: resource.artist.to_param, id: resource.to_param
    assert_redirected_to send('artist_path', resource.artist)
  end
end
