require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  setup do
    5.times{ Page.sham! }
  end

  context 'GET index' do
    setup { get :index }

    should 'be successful' do
      assert_redirected_to page_url( Page.first )
    end
  end

  context 'GET show' do
    setup do
      @page = Page.first
      get :show, :id => @page.to_param
    end

    should 'be successful' do
      assert_response :success
      assert_template 'application'
      assert_equal @page, assigns( :page )
    end

    should 'show headers' do
      assert_select "title", build_title( @page.title )
      assert_select 'h1', @page.title
    end
  end

  context 'for user' do
    setup do
      activate_authlogic
      @user = User.sham!
      UserSession.create @user
    end

    context 'GET show' do
      setup do
        @page = Page.first
        get :show, :id => @page.to_param
      end

      should 'not display actions' do
        assert_select 'a[href=?]', new_post_path, 0
        assert_select 'a[href=?]', new_page_path, 0
        assert_select 'a[href=?]', edit_page_path( @page ), 0
        assert_select 'a[href=?][data-method=delete]', page_path( @page ), 0
      end
    end

    should 'refute edit' do
      assert_raise( CanCan::AccessDenied ) do
        get :edit, :id => Page.first.to_param
      end
    end

    should 'refute new' do
      assert_raise( CanCan::AccessDenied ) do
        get :new
      end
    end

    should 'refute update' do
      assert_raise( CanCan::AccessDenied ) do
        put :update, :id => Page.first.to_param, :page => {}
      end
    end

    should 'refute create' do
      assert_raise( CanCan::AccessDenied ) do
        post :create, :page => {}
      end
    end

    should 'refute destroy' do
      assert_raise( CanCan::AccessDenied ) do
        delete :destroy, :id => Page.first.to_param
      end
    end
  end

  context 'for admin' do
    setup do
      activate_authlogic
      @user = User.sham! :admin
      UserSession.create @user
    end

    context 'GET edit' do
      setup do
        @page = Page.first
        get :edit, :id => @page.to_param
      end

      should 'display actions' do
        assert_select 'a[href=?]', page_path( @page ), I18n.t( 'helpers.action.cancel_edit' )
      end

      should 'display headers' do
        assert_select "title", build_title( I18n.t( 'helpers.title.page.edit' ) )
        assert_select "h1", I18n.t( 'helpers.title.page.index' )
        assert_select "h2", I18n.t( 'helpers.title.page.edit' )
      end

      should 'display form' do
        assert_select 'form' do
          assert_select 'label', I18n.t( 'helpers.label.page.title' )
          assert_select 'input[type=text][name=?][value=?]', 'page[title]', @page.title
          assert_select 'label', I18n.t( 'helpers.label.page.reference' )
          assert_select 'input[type=text][name=?][value=?][disabled=disabled]', 'page[reference]', @page.reference
          assert_select 'label', I18n.t( 'helpers.label.page.content' )
          assert_select 'textarea[name=?]', 'page[content]', @page.content
          assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
        end
      end
    end

    context 'GET show' do
      setup do
        @page = Page.first
        get :show, :id => @page.to_param
      end

      should 'display actions' do
        assert_select 'a[href=?]', new_page_path, I18n.t( 'helpers.action.page.new' )
        assert_select 'a[href=?]', edit_page_path( @page ), I18n.t( 'helpers.action.page.edit' )
        assert_select 'a[href=?][data-method=delete]', page_path( @page ), I18n.t( 'helpers.action.page.destroy' )
      end
    end

    context 'GET new' do
      setup do
        get :new
      end

      should 'display headers' do
        assert_select "title", build_title( I18n.t( 'helpers.title.page.new' ) )
        assert_select "h1", I18n.t( 'helpers.title.page.index' )
        assert_select "h2", I18n.t( 'helpers.title.page.new' )
      end

      should 'display actions' do
        assert_select 'a[href=?]', pages_path, I18n.t( 'helpers.action.cancel_new' )
      end

      should 'display form' do
        assert_select 'form' do
          assert_select 'label', I18n.t( 'helpers.label.page.title' )
          assert_select 'input[type=text][name=?]', 'page[title]'
          assert_select 'label', I18n.t( 'helpers.label.page.reference' )
          assert_select 'input[type=text][name=?][disabled=disabled]', 'page[reference]', 0
          assert_select 'input[type=text][name=?]', 'page[reference]'
          assert_select 'label', I18n.t( 'helpers.label.page.content' )
          assert_select 'textarea[name=?]', 'page[content]'
          assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
        end
      end
    end

    context 'PUT update' do
      setup do
        @page = Page.first
      end
      
      should 'update' do
        title = Faker::Name.name

        put :update, :id => @page.to_param, :page => {title: title}
        assert_equal title, assigns( :page ).title
        assert_redirected_to page_url( assigns( :page ) )
      end
    end

    context 'POST create' do
      should 'create' do
        attributes = Page.sham!( :build ).attributes
        attributes.delete :created_at
        attributes.delete :updated_at
        assert_difference 'Page.count' do
          post :create, :page => attributes
        end
        assert_redirected_to page_url( assigns( :page ) )
      end
    end

    context 'DELETE destroy' do
      setup do
        @page = Page.first
      end
      
      should 'create' do
        assert_difference 'Page.count', -1 do
          delete :destroy, :id => @page.to_param
        end
        assert_redirected_to pages_url
      end
    end

	end
end

