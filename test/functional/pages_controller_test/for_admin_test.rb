require 'test_helper'

module PagesControllerTest
  class ForAdminTest < ActionController::TestCase
    def setup
      @controller = PagesController.new
      activate_authlogic
      @user = User.sham! :admin
      UserSession.create @user
    end

    def test_get_edit_displays_actions
      page = Page.sham!
      get :edit, :id => page.to_param
      assert_select 'a[href=?]', page_path( page ), I18n.t( 'helpers.action.cancel_edit' )
    end

    def test_get_edit_displays_headers
      page = Page.sham!
      get :edit, :id => page.to_param
      assert_select "title", build_title( I18n.t( 'helpers.title.page.edit' ) )
      assert_select "h1", I18n.t( 'helpers.title.page.index' )
      assert_select "h2", I18n.t( 'helpers.title.page.edit' )
    end

    def test_get_edit_displays_form
      page = Page.sham!
      get :edit, :id => page.to_param
      assert_select 'form' do
        assert_select 'label', I18n.t( 'helpers.label.page.title' )
        assert_select 'input[type=text][name=?][value=?]', 'page[title]', page.title
        assert_select 'label', I18n.t( 'helpers.label.page.reference' )
        assert_select 'input[type=text][name=?][value=?][disabled=disabled]', 'page[reference]', page.reference
        assert_select 'label', I18n.t( 'helpers.label.page.content' )
        assert_select 'textarea[name=?]', 'page[content]', page.content
        assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
      end
    end

    def test_get_show_displays_actions
      page = Page.sham!
      get :show, :id => page.to_param
      assert_select 'a[href=?]', new_page_path, I18n.t( 'helpers.action.page.new' )
      assert_select 'a[href=?]', edit_page_path( page ), I18n.t( 'helpers.action.page.edit' )
      assert_select 'a[href=?][data-method=delete]', page_path( page ), I18n.t( 'helpers.action.page.destroy' )
    end

    def test_get_new_displays_headers
      get :new
      assert_select "title", build_title( I18n.t( 'helpers.title.page.new' ) )
      assert_select "h1", I18n.t( 'helpers.title.page.index' )
      assert_select "h2", I18n.t( 'helpers.title.page.new' )
    end

    def test_get_new_displays_actions
      get :new
      assert_select 'a[href=?]', pages_path, I18n.t( 'helpers.action.cancel_new' )
    end

    def test_get_new_displays_form
      get :new
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

    def test_put_update_succeeds
      page = Page.sham!
      title = Faker::Name.name
      put :update, :id => page.to_param, :page => {title: title}
      page.reload
      assert_equal title, page.title
      assert_redirected_to page_url( page )
    end

    def test_post_create_succeeds
      page = Page.sham!( :build )
      pages_count = Page.count
      post :create, :page => page.attributes
      assert_equal pages_count + 1, Page.count
      assert_redirected_to page_url( assigns( :page ) )
    end

    def test_delete_destroy_succeeds
      page = Page.sham!
      pages_count = Page.count
      delete :destroy, :id => page.to_param
      assert_equal pages_count - 1, Page.count
      assert_redirected_to pages_url
    end
	end
end

