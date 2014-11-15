module ResourcesControllerTest
  module PutUpdate
    def test_put_update_without_artist_is_not_routable
      assert_raises ActionController::UrlGenerationError do
        put :update, id: resource_class.sham!.id, resource_name.to_sym => {}
      end
    end
  end
end
