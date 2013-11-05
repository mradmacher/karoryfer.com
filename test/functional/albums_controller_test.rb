# encoding: utf-8
require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  setup do
    20.times { Album.sham!( :published ) }
  end

  should 'get index' do
    get :index
    assert_response :success
    refute_nil assigns( :albums )
    assert_equal Album.published.all, assigns( :albums )
  end

  should 'not index unpublished albums' do
    get :index
    Album.unpublished.each do |a|
      assert_select a.title, 0
    end
  end

  should 'properly render headers while getting index' do
    get :index
    assert_select "title", build_title( I18n.t( 'helpers.title.album.index' ) )
    assert_select 'h1', I18n.t( 'helpers.title.album.index' )
  end

  should 'get show' do
    album = Album.first
    get :show, :artist_id => album.artist.to_param, :id => album.to_param
    assert_response :success
    assert_template 'application'
    assert_equal album, assigns( :album )
  end

  should 'not show unpublished albums' do
    album = Album.sham!( :unpublished )
    assert_raise( CanCan::AccessDenied ) do
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
    end
  end

  should 'properly render headers while getting show' do
    album = Album.first
    get :show, :artist_id => album.artist.to_param, :id => album.to_param
    assert_select "title", build_title( album.title, album.artist.name )
    assert_select 'h1', album.artist.name
    assert_select 'h2', I18n.t( 'helpers.title.album.index' ) 
    assert_select 'h3', album.title
    assert_select 'h4', album.year.to_s
  end

  should 'not show actions on index' do
    get :index
    assert_select 'a[href=?]', new_album_path, 0
  end

  should 'not show actions on show' do
    album = Album.first
    get :show, :artist_id => album.artist.to_param, :id => album.to_param
    assert_select 'a[href=?]', new_album_path, 0
    assert_select 'a[href=?]', edit_album_path( album ), 0
    assert_select 'a[href=?][data-method=delete]', album_path( album ), 0
  end

  should 'refute access to new' do
    assert_raise( CanCan::AccessDenied ) do
      get :new
    end
  end

  should 'refute access to edit' do
    album = Album.first
    assert_raise( CanCan::AccessDenied ) do
      get :edit, :artist_id => album.artist.to_param, :id => album.to_param
    end
  end

  should 'refute access to create' do
    assert_raise( CanCan::AccessDenied ) do
      post :create, :album => {}
    end
  end

  should 'refute access to update' do
    assert_raise( CanCan::AccessDenied ) do
      put :update, :id => Album.first.to_param, :album => {}
    end
  end

  should 'refute access to destroy' do
    assert_raise( CanCan::AccessDenied ) do
      delete :destroy, :id => Album.first.to_param
    end
  end


  context 'for user' do
    setup do
      activate_authlogic
      @user = User.sham!
      UserSession.create @user
    end

    should 'not index unpublished albums' do
      get :index
      Album.unpublished.each do |a|
        assert_select a.title, 0
      end
    end

    should 'not show unpublished albums' do
      album = Album.sham!( :unpublished )
      assert_raise( CanCan::AccessDenied ) do
        get :show, :artist_id => album.artist.to_param, :id => album.to_param
      end
    end

    should 'not show actions on index' do
      get :index
      assert_select 'a[href=?]', new_album_path, 0
    end

    should 'not show actions on show' do
      album = Album.first
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]', new_album_path, 0
      assert_select 'a[href=?]', edit_album_path( album ), 0
      assert_select 'a[href=?][data-method=delete]', album_path( album ), 0
    end

    should 'refute access to new' do
      assert_raise( CanCan::AccessDenied ) do
        get :new
      end
    end

    should 'refute access to edit' do
      album = Album.first
      assert_raise( CanCan::AccessDenied ) do
        get :edit, :artist_id => album.artist.to_param, :id => album
      end
    end

    should 'refute access to create' do
      assert_raise( CanCan::AccessDenied ) do
        post :create, :album => Album.first.attributes
      end
    end

    should 'refute access to update' do
      assert_raise( CanCan::AccessDenied ) do
        put :update, :id => Album.first.id, :album => {}
      end
    end

    should 'refute access to destroy' do
      assert_raise( CanCan::AccessDenied ) do
        delete :destroy, :id => Album.first.to_param
      end
    end
  end

  context 'for admin' do
    setup do
      activate_authlogic
      @user = User.sham!( :admin )
      UserSession.create @user
    end

    should 'index unpublished' do
      get :index
      Album.unpublished.each do |p|
        assert_select "a", p.title
      end
    end

    should 'show unpublished album' do
      album = Album.sham!( :unpublished )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_response :success
    end

    context 'get new' do
      setup do
        get :new
      end

      should 'be success' do
        assert_response :success
        assert_template 'application'
        refute_nil assigns( :album )
        assert assigns( :album ).new_record?
      end

      should 'show proper headers' do
        assert_select "title", build_title( I18n.t( 'helpers.title.album.new' ) )
        assert_select "h1", I18n.t( 'helpers.title.album.index' )
        assert_select "h2", I18n.t( 'helpers.title.album.new' )
      end

      should 'show form' do
        assert_select 'form[enctype="multipart/form-data"]' do
          assert_select 'label', I18n.t( 'helpers.label.album.title' )
          assert_select 'input[type=text][name=?]', 'album[title]'
          assert_select 'label', I18n.t( 'helpers.label.album.artist_id' )
          assert_select 'label', I18n.t( 'helpers.label.album.published' )
          Artist.all.each do |g|
            assert_select 'option[value=?]', g.id, g.name
          end
          assert_select 'label', I18n.t( 'helpers.label.album.year' )
          assert_select 'input[type=number][name=?]', 'album[year]'
          assert_select 'label', I18n.t( 'helpers.label.album.image' )
          assert_select 'input[type=file][name=?]', 'album[image]'
          assert_select 'select[name=?]', 'album[license_id]' do
            assert_select 'option[value=?]', ''
            License::all.each do |license|
              assert_select 'option[value=?]', license.id, license.name
            end
          end
          assert_select 'label', I18n.t( 'helpers.label.album.donation' )
          assert_select 'textarea[name=?]', 'album[donation]'
          assert_select 'label', I18n.t( 'helpers.label.album.description' )
          assert_select 'textarea[name=?]', 'album[description]'
          assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
        end
      end

      should 'show actions' do
        assert_select 'a[href=?]', albums_path, I18n.t( 'helpers.action.cancel_new' )
      end
    end

    context 'get edit' do
      setup do
        @album = Album.first
        get :edit, :artist_id => @album.artist.to_param, :id => @album.to_param
      end

      should 'be success' do
        assert_response :success
        assert_template 'application'
        assert_equal @album, assigns( :album )
      end

      should 'show headers' do
        assert_select "title", build_title( I18n.t( 'helpers.title.album.edit' ), assigns( :album ).title, assigns( :album ).artist.name )
        assert_select "h1", I18n.t( 'helpers.title.album.index' )
        assert_select "h2", I18n.t( 'helpers.title.album.edit' )
      end

      should 'show form' do
        assert_select 'form[enctype="multipart/form-data"]' do
          assert_select 'label', I18n.t( 'helpers.label.album.title' )
          assert_select 'input[type=text][name=?][value=?]', 'album[title]', @album.title
          assert_select 'label', I18n.t( 'helpers.label.album.published' )
          assert_select 'label', I18n.t( 'helpers.label.album.artist_id' )
          Artist.all.each do |g|
            assert_select 'option[value=?]', g.id, g.name
          end
          assert_select 'option[value=?][selected]', @album.artist_id
          assert_select 'label', I18n.t( 'helpers.label.album.year' )
          assert_select 'input[type=number][name=?][value=?]', 'album[year]', @album.year
          assert_select 'label', I18n.t( 'helpers.label.album.image' )
          assert_select 'input[type=file][name=?]', 'album[image]'
          assert_select 'select[name=?]', 'album[license_id]' do
            assert_select 'option[value=?]', ''
            License.all.each do |license|
              if @album.license == license  
                assert_select 'option[value=?][selected=selected]', license.id, license.name
              else
                assert_select 'option[value=?][selected=selected]', license.id, 0
                assert_select 'option[value=?]', license.id, license.name
              end
            end
          end
          assert_select 'label', I18n.t( 'helpers.label.album.donation' )
          assert_select 'textarea[name=?]', 'album[donation]', @album.donation
          assert_select 'label', I18n.t( 'helpers.label.album.description' )
          assert_select 'textarea[name=?]', 'album[description]', @album.description
          assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
        end
      end

      should 'show actions' do
        assert_select 'a[href=?]', album_path( @album ), I18n.t( 'helpers.action.cancel_edit' )
      end
    end

    should 'show actions on index page' do
      get :index
      assert_select 'a[href=?]', new_album_path, I18n.t( 'helpers.action.album.new' )
    end

    should 'show actions on show page' do
      album = Album.first
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]', edit_artist_album_path, I18n.t( 'helpers.action.album.edit' )
      #assert_select 'a[href=?][data-method=delete]', album_path( album ), I18n.t( 'helpers.action.album.destroy' )
      assert_select 'a[href=?][data-method=delete]', album_path( album ), 0
    end

    should 'create' do
      attributes = Album.sham!( :build ).attributes
      attributes.delete(:created_at)
      attributes.delete(:updated_at)
      assert_difference 'Album.count' do
        post :create, :album => attributes
      end
      refute_nil assigns( :album )
      assert_redirected_to artist_album_url( assigns( :album ).artist, assigns( :album ) )
    end

    should 'update' do
      old_album = Album.first
      title = Faker::Name.name
      put :update, :id => old_album.to_param, :album => {:title => title}
      assert_not_nil assigns( :album )
      assert_equal assigns( :album ).title, title
      assert_redirected_to artist_album_url( assigns( :album ).artist, assigns( :album ) )
    end

  end

end

