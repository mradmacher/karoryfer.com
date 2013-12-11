require 'test_helper'

module AlbumsControllerTest
  class ForGuestTest < ActionController::TestCase
    def setup
      @controller = AlbumsController.new
    end

    def test_get_index_succeeds
      10.times { Album.sham!( :published ) }
      get :index
      assert_response :success
    end

    def test_get_index_does_not_show_unpublished
      5.times { Album.sham!( :published ) }
      5.times { Album.sham!( :unpublished ) }
      get :index
      Album.unpublished.each do |a|
        assert_select a.title, 0
      end
    end

    def test_get_index_displays_headers
      get :index
      assert_select "title", build_title( I18n.t( 'helpers.title.album.index' ) )
      assert_select 'h1', I18n.t( 'helpers.title.album.index' )
    end

    def test_get_show_succeeds
      album = Album.sham!( :published )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_response :success
    end

    def test_get_show_is_denied_for_unpublished_album
      album = Album.sham!( :unpublished )
      assert_raises User::AccessDenied do
        get :show, :artist_id => album.artist.to_param, :id => album.to_param
      end
    end

    def test_get_show_displays_headers
      album = Album.sham!( :published )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select "title", build_title( album.title, album.artist.name )
      assert_select 'h1', album.artist.name
      assert_select 'h2', I18n.t( 'helpers.title.album.index' )
      assert_select 'h3', album.title
      assert_select 'h4', album.year.to_s
    end

    def test_get_index_does_not_display_actions
      get :index
      assert_select 'a[href=?]', new_album_path, 0
    end

    def test_get_show_does_not_display_actions
      album = Album.sham!( :published )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]', new_album_path, 0
      assert_select 'a[href=?]', edit_album_path( album ), 0
      assert_select 'a[href=?][data-method=delete]', album_path( album ), 0
    end

    def test_get_new_is_denied
      assert_raises User::AccessDenied do
        get :new
      end
    end

    def test_get_edit_is_denied
      album = Album.sham!
      assert_raises User::AccessDenied do
        get :edit, :artist_id => album.artist.to_param, :id => album.to_param
      end
    end

    def test_post_create_is_denied
      assert_raises User::AccessDenied do
        post :create, :album => {}
      end
    end

    def test_put_update_is_denied
      assert_raises User::AccessDenied do
        put :update, :id => Album.sham!.to_param, :album => {}
      end
    end

    def test_delete_destroy_is_denied
      assert_raises User::AccessDenied do
        delete :destroy, :id => Album.sham!.to_param
      end
    end
  end
end

