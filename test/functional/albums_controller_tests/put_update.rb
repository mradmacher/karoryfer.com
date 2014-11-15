module AlbumsControllerTests
  module PutUpdate
    def test_put_update_without_artist_is_not_routable
      assert_raises ActionController::UrlGenerationError do
        put :update, :id => 1, :album => {}
      end
    end
  end
end
