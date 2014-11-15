module AlbumsControllerTests
  module PostCreate
    def test_post_create_without_artist_is_not_routable
      assert_raises ActionController::UrlGenerationError do
        post :create, :album => {}
      end
    end
  end
end
