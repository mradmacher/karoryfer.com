module ResourcesControllerTest
  module Authorize
    def test_get_edit_is_authorized
      resource = resource_class.sham!
      assert_authorized :write, resource do
        get :edit, :artist_id => resource.artist.to_param, :id => resource.to_param
      end
    end

    def test_get_new_is_authorized
      artist = Artist.sham!
      assert_authorized :write, resource_class, artist do
        get :new, artist_id: artist.to_param
      end
    end

    def test_get_show_is_authorized
      resource = resource_class.sham!
      assert_authorized :read, resource do
        get :show, :artist_id => resource.artist.to_param, :id => resource.to_param
      end
    end

    def test_delete_destroy_is_authorized
      resource = resource_class.sham!
      assert_authorized :write, resource do
        delete :destroy, artist_id: resource.artist.to_param, :id => resource.to_param
      end
    end

    def test_post_create_is_authorized
      artist = Artist.sham!
      assert_authorized :write, resource_class, artist do
        post :create, artist_id: artist.to_param, resource_name.to_sym => {a: 1}
      end
    end

    def test_put_update_is_authorized
      resource = resource_class.sham!
      assert_authorized :write, resource do
        put :update, artist_id: resource.artist.to_param, :id => resource.to_param,
          resource_name.to_sym => {a: 1}
      end
    end
  end
end

