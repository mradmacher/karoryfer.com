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
    assert_raises ActionController::RoutingError do
      get :edit, artist_id: attachment.album.artist.to_param,
        album_id: attachment.album.to_param,
        id: attachment.to_param
    end
  end

  def test_get_new_without_album_is_not_routable
    assert_raises ActionController::RoutingError do
      get :new
    end
  end

  def test_authorized_get_new_succeeds
    album = Album.sham!
    allow(:write, Attachment, album)
    get :new, artist_id: album.artist.to_param, album_id: album.to_param
    assert_response :success
  end

  def test_post_create_without_album_is_not_routable
    assert_raises ActionController::RoutingError do
      post :create, attachment: {}
    end
  end

  def test_put_update_is_not_routable
    attachment = Attachment.sham!
    assert_raises ActionController::RoutingError do
      put :update, artist_id: attachment.album.artist.to_param,
        album_id: attachment.album.to_param,
        id: attachment.to_param
    end
  end

  def test_delete_destroy_without_album_is_not_routable
    assert_raises ActionController::RoutingError do
      delete :destroy, id: 1
    end
  end

  def test_authorized_post_create_creates_attachment
    album = Album.sham!
    allow(:write, Attachment, album)
    attachments_count = album.attachments.count
    post :create, artist_id: album.artist.to_param, album_id: album.to_param,
      attachment: {album_id: album.id, file: fixture_file_upload('attachments/att1.jpg')}
    assert_equal attachments_count + 1, album.attachments.count
    assert_redirected_to artist_album_url( album.artist, album )
  end

  def test_authorized_post_create_does_not_change_album
    album = Album.sham!
    allow(:write, Attachment, album)
    other_album = Album.sham!
    attachments_count = album.attachments.count

    post :create, artist_id: album.artist.to_param, album_id: album.to_param,
      attachment: {album_id: other_album.id, file: fixture_file_upload('attachments/att1.jpg')}
    attachment = Attachment.order('created_at desc').first
    assert_equal album, attachment.album
  end

  def test_authorized_delete_destroy_succeeds
    attachment = Attachment.sham!
    allow(:write, attachment)
    album = attachment.album
    attachments_count = album.attachments.count
    delete :destroy, artist_id: attachment.album.artist.to_param,
      album_id: attachment.album.to_param, :id => attachment.to_param
    assert_equal attachments_count - 1, album.attachments.count
    refute Attachment.where( id: attachment.id ).exists?
  end

  def test_delete_destroy_for_admin_properly_redirects
    attachment = Attachment.sham!
    allow(:write, attachment)
    delete :destroy, artist_id: attachment.album.artist.to_param,
      album_id: attachment.album.to_param, :id => attachment.to_param
    assert_redirected_to artist_album_path( attachment.album.artist, attachment.album )
  end
end

