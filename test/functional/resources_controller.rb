# frozen_string_literal: true

module ResourcesController
  def test_delete_destroy_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      delete :destroy, id: resource_class.sham!.to_param
    end
  end

  def test_delete_destroy_for_artist_user_properly_redirects
    membership = login_artist_user
    resource = resource_class.sham!(artist: membership.artist)
    delete :destroy, artist_id: resource.artist.to_param, id: resource.to_param
    assert_redirected_to send("artist_#{resource_name.pluralize}_path", resource.artist)
  end

  def test_get_edit_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :edit, id: resource_class.sham!.to_param
    end
  end

  def test_get_index_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :index
    end
  end

  def test_get_new_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :new
    end
  end

  def test_get_show_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :show, id: resource_class.sham!.to_param
    end
  end

  def test_post_create_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      post :create, resource_name.to_sym => {}
    end
  end

  def test_put_update_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      put :update, id: resource_class.sham!.id, resource_name.to_sym => {}
    end
  end
end
