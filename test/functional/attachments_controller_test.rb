require 'test_helper'

class AttachmentsControllerTest < ActionController::TestCase
  def test_get_index_without_album_is_not_routable
    assert_raises ActionController::RoutingError do
      get :index
    end
  end

  def test_get_index_for_guest_is_denied
    album = Album.sham!
    assert_raises User::AccessDenied do
      get :index, artist_id: album.artist.to_param, album_id: album.to_param
    end
  end

  def test_get_index_for_artist_user_is_denied
    membership = Membership.sham!
    login( membership.user )
    album = Album.sham!( artist: membership.artist )
    assert_raises User::AccessDenied do
      get :index, artist_id: album.artist.to_param, album_id: album.to_param
    end
  end

  def test_get_index_for_admin_succeeds
    login( User.sham!( :admin ) )
    album = Album.sham!
    get :index, artist_id: album.artist.to_param, album_id: album.to_param
    assert_response :success
  end

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

  def test_get_new_for_guest_is_denied
    album = Album.sham!
    assert_raises User::AccessDenied do
      get :new, artist_id: album.artist.to_param, album_id: album.to_param
    end
  end

  def test_get_new_for_artist_user_is_denied
    membership = Membership.sham!
    login( membership.user )
    album = Album.sham!( artist: membership.artist )
    assert_raises User::AccessDenied do
      get :new, artist_id: album.artist.to_param, album_id: album.to_param
    end
  end

  def test_get_new_for_admin_succeeds
    login( User.sham!( :admin ) )
    album = Album.sham!
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

  def test_post_create_for_guest_is_denied
    album = Album.sham!
    assert_raises User::AccessDenied do
      post :create, artist_id: album.artist.to_param, album_id: album.to_param, attachment: {}
    end
  end

  def test_post_create_for_artist_user_is_denied
    membership = Membership.sham!
    login( membership.user )
    album = Album.sham!( artist: membership.artist )
    assert_raises User::AccessDenied do
      post :create, artist_id: album.artist.to_param, album_id: album.to_param, attachment: {}
    end
  end

  def test_delete_destroy_for_guest_is_denied
    attachment = Attachment.sham!
    assert_raises User::AccessDenied do
      delete :destroy, artist_id: attachment.album.artist.to_param,
        album_id: attachment.album.to_param,
        id: attachment.to_param
    end
  end

  def test_delete_destroy_for_artist_user_is_denied
    membership = Membership.sham!
    login( membership.user )
    album = Album.sham!( artist: membership.artist )
    attachment = Attachment.sham!(album: album)
    assert_raises User::AccessDenied do
      delete :destroy, artist_id: attachment.album.artist.to_param,
        album_id: attachment.album.to_param,
        id: attachment.to_param
    end
  end

  def test_post_create_for_admin_creates_attachment
    login( User.sham!( :admin ) )
    album = Album.sham!
    attachment = Attachment.sham!( :build )
    attachments_count = album.attachments.count
    post :create, artist_id: album.artist.to_param, album_id: album.to_param, attachment: attachment.attributes
    assert_equal attachments_count + 1, album.attachments.count
    assert_redirected_to artist_album_attachments_url( album.artist, album )
  end

  def test_post_create_for_admin_does_not_change_album
    login( User.sham!( :admin ) )
    album = Album.sham!
    other_album = Album.sham!
    attachment = Attachment.sham!( :build, album: other_album )
    attachments_count = album.attachments.count
    post :create, artist_id: album.artist.to_param, album_id: album.to_param, attachment: attachment.attributes
    attachment = Attachment.order('created_at desc').first
    assert_equal album, attachment.album
  end

  def test_delete_destroy_for_admin_succeeds
    login( User.sham!( :admin ) )
    attachment = Attachment.sham!
    album = attachment.album
    attachments_count = album.attachments.count
    delete :destroy, artist_id: attachment.album.artist.to_param,
      album_id: attachment.album.to_param, :id => attachment.to_param
    assert_equal attachments_count - 1, album.attachments.count
    refute Attachment.where( id: attachment.id ).exists?
  end

  def test_delete_destroy_for_admin_properly_redirects
    login( User.sham!( :admin ) )
    attachment = Attachment.sham!
    delete :destroy, artist_id: attachment.album.artist.to_param,
      album_id: attachment.album.to_param, :id => attachment.to_param
    assert_redirected_to artist_album_attachments_path( attachment.album.artist, attachment.album )
  end
end

