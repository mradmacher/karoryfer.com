require 'test_helper'

class ArtistsControllerTest < ActionController::TestCase
  setup do
    10.times { Artist.sham! }
  end

  should 'get index' do
    get :index
    assert_template 'application'
    assert_response :success
    assert_not_nil assigns( :artists )
  end

  should 'show headers on index page' do
    get :index
    assert_select "title", build_title( I18n.t( 'helpers.title.artist.index' ) )
    assert_select "h1", I18n.t( 'helpers.title.artist.index' )
  end

  should 'get show' do
    artist = Artist.first
    get :show, :id => artist.to_param
    assert_template 'current_artist'
    assert_response :success
    assert_equal artist, assigns( :artist )
  end

  should 'show headers on show page' do
    get :show, :id => Artist.first.to_param
    assert_select "title", build_title( assigns( :artist ).name )
    assert_select "h1", assigns( :artist ).name
  end


  should 'refute access to new' do
    assert_raise( CanCan::AccessDenied ) do
      get :new
    end
  end

  should 'refute access to edit' do
    assert_raise( CanCan::AccessDenied ) do
      get :edit, :id => Artist.first.to_param
    end
  end

  should 'refute access to create' do
    assert_raise( CanCan::AccessDenied ) do
      post :create, :artist => {}
    end
  end

  should 'refute access to update' do
    assert_raise( CanCan::AccessDenied ) do
      put :update, :id => Artist.first.id, :artist => {}
    end
  end

  should 'not show actions on index page' do
    get :index
    assert_select 'a[href=?]', new_artist_path, 0
  end

  should 'not show actions on show page' do
    artist = Artist.first
    get :show, :id => artist.to_param
    assert_select 'a[href=?]', edit_artist_path, 0
    assert_select 'a[href=?][data-method=delete]', artist_path( artist ), 0
  end


  context 'for user' do
    setup do
      activate_authlogic
      @user = User.sham!
      UserSession.create @user
    end

    should 'refute access to new' do
      assert_raise( CanCan::AccessDenied ) do
        get :new
      end
    end

    should 'refute access to edit' do
      assert_raise( CanCan::AccessDenied ) do
        get :edit, :id => Artist.first.to_param
      end
    end

    should 'refute access to create' do
      assert_raise( CanCan::AccessDenied ) do
        post :create, :artist => {}
      end
    end

    should 'refute access to update' do
      assert_raise( CanCan::AccessDenied ) do
        put :update, :id => Artist.first.to_param, :artist => {}
      end
    end

    should 'not show actions on index page' do
      get :index
      assert_select 'a[href=?]', new_artist_path, 0
    end

    should 'not show actions on show page' do
      artist = Artist.first
      get :show, :id => artist.to_param
      assert_select 'a[href=?]', edit_artist_path, 0
      assert_select 'a[href=?][data-method=delete]', artist_path( artist ), 0
    end

  end

  context 'for admin' do
    setup do
      activate_authlogic
      @user = User.sham! :admin
      UserSession.create @user
    end

    context 'get new' do
      setup do
        get :new
      end

      should 'be success' do
        assert_template 'application'
        assert_response :success
        assert_not_nil new_artist = assigns( :artist )
      end

      should 'show headers' do
        assert_select "title", build_title( I18n.t( 'helpers.title.artist.new' ) )
        assert_select "h1", I18n.t( 'helpers.title.artist.new' )
      end
      
      should 'show actions' do
        assert_select 'a[href=?]', artists_path, I18n.t( 'helpers.action.cancel_new' )
      end

      should 'show form' do
        assert_select 'form[enctype="multipart/form-data"]' do
          assert_select 'label', I18n.t( 'helpers.label.artist.name' )
          assert_select 'input[type=text][name=?]', 'artist[name]'
          assert_select 'label', I18n.t( 'helpers.label.artist.reference' )
          assert_select 'input[type=text][name=?]', 'artist[reference]'
          assert_select 'label', I18n.t( 'helpers.label.artist.image' )
          assert_select 'input[type=file][name=?]', 'artist[image]'
          assert_select 'label', I18n.t( 'helpers.label.artist.summary' )
          assert_select 'input[type=text][name=?]', 'artist[summary]'
          assert_select 'label', I18n.t( 'helpers.label.artist.description' )
          assert_select 'textarea[name=?]', 'artist[description]'
          assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
        end
      end

    end

    context 'get edit' do
      setup do
        @artist = Artist.first
        get :edit, :id => @artist.to_param
      end

      should 'be success' do
        assert_template 'current_artist'
        assert_response :success
        assert_not_nil assigns( :artist )
        assert_equal @artist, assigns( :artist )
      end

      should 'show headers' do
        assert_select "title", build_title( I18n.t( 'helpers.title.artist.edit' ), @artist.name )
        assert_select 'h1', @artist.name
        assert_select 'h2', I18n.t( 'helpers.title.artist.edit' )
      end

      should 'show actions' do
        assert_select 'a[href=?]', artist_path( @artist ), I18n.t( 'helpers.action.cancel_edit' )
      end

      should 'show form' do
        assert_select 'form[enctype="multipart/form-data"]' do
          assert_select 'label', I18n.t( 'helpers.label.artist.name' )
          assert_select 'input[type=text][name=?][value=?]', 'artist[name]', @artist.name
          assert_select 'label', I18n.t( 'helpers.label.artist.reference' )
          assert_select 'input[type=text][name=?][value=?]', 'artist[reference]', @artist.reference
          assert_select 'label', I18n.t( 'helpers.label.artist.image' )
          assert_select 'input[type=file][name=?]', 'artist[image]'
          assert_select 'label', I18n.t( 'helpers.label.artist.summary' )
          assert_select 'input[type=text][name=?]', 'artist[summary]', @artist.summary
          assert_select 'label', I18n.t( 'helpers.label.artist.description' )
          assert_select 'textarea[name=?]', 'artist[description]', @artist.description
          assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
        end
      end
    end
    
    should 'create' do
      attributes = Artist.sham!( :build ).attributes
      attributes.delete :created_at
      attributes.delete :updated_at
      assert_difference 'Artist.count' do
        post :create, :artist => attributes
      end
      assert_not_nil assigns( :artist )
      assert_redirected_to artist_url( assigns( :artist ) )
    end

    should 'update' do
      artist = Artist.first
      name = Faker::Name.name
      put :update, :id => artist.to_param, :artist => {name: name}
      assert_not_nil assigns( :artist )
      assert_equal name, assigns( :artist ).name
      assert_redirected_to artist_url( assigns( :artist ) )
    end

    should 'show actions on index page' do
      get :index
      assert_select 'a[href=?]', new_artist_path, I18n.t( 'helpers.action.artist.new' )
    end

    should 'show actions on show page' do
      artist = Artist.first
      get :show, :id => artist.to_param
      assert_select 'a[href=?]', edit_artist_path, I18n.t( 'helpers.action.artist.edit' )
      assert_select 'a[href=?]', new_post_path, I18n.t( 'helpers.action.post.new' )
      #assert_select 'a[href=?][data-method=delete]', artist_path( artist ), I18n.t( 'helpers.action.artist.destroy' )
      assert_select 'a[href=?][data-method=delete]', artist_path( artist ), 0
    end

  end

end

