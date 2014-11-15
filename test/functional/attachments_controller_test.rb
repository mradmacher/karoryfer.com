require 'test_helper'

class AttachmentsControllerTest < ActionController::TestCase
  def test_get_show_redirects_to_file_url
    attachment = Attachment.sham!
    get :show, artist_id: attachment.album.artist.to_param,
      album_id: attachment.album.to_param,
      id: attachment.to_param
    assert_redirected_to attachment.file.url
  end

  def test_get_edit_is_not_routable
    attachment = Attachment.sham!
    assert_raises ActionController::UrlGenerationError do
      get :edit, artist_id: attachment.album.artist.to_param,
        album_id: attachment.album.to_param,
        id: attachment.to_param
    end
  end

  def test_get_new_without_album_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :new
    end
  end

  def test_post_create_without_album_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      post :create, attachment: {a: 1}
    end
  end

  def test_put_update_is_not_routable
    attachment = Attachment.sham!
    assert_raises ActionController::UrlGenerationError do
      put :update, artist_id: attachment.album.artist.to_param,
        album_id: attachment.album.to_param,
        id: attachment.to_param
    end
  end

  def test_delete_destroy_without_album_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      delete :destroy, id: 1
    end
  end

  def test_delete_destroy_for_admin_properly_redirects
    attachment = Attachment.sham!
    allow(:write, attachment)
    delete :destroy, artist_id: attachment.album.artist.to_param,
      album_id: attachment.album.to_param, :id => attachment.to_param
    assert_redirected_to artist_album_path( attachment.album.artist, attachment.album )
  end
end
