require 'test_helper'

module UsersControllerTest
  class ForAdminTest < ActionController::TestCase
    def setup
      @controller = UsersController.new
      activate_authlogic
      @user = User.sham! :admin
      @other_user = User.sham!
      UserSession.create @user
    end

    def test_get_index_succeeds
      get :index
      assert_response :success
    end

    def test_get_show_for_other_user_succeeds
      get :show, :id => @other_user.to_param
      assert_response :success
    end

    def test_get_show_for_other_user_displays_memberships
      memberships = []
      memberships << Membership.sham!( user: @other_user )
      memberships << Membership.sham!( user: @other_user )
      memberships << Membership.sham!( user: @other_user )
      get :show, :id => @other_user.to_param
      assert_select 'ul[class=user-memberships]' do
        memberships.each do |membership|
          assert_select 'li', /#{membership.artist.name}/
        end
      end
    end

    def test_get_show_for_other_user_displays_memberships_only_for_that_user
      other_membership = Membership.sham!
      get :show, :id => @other_user.to_param
      assert_select 'ul[class=user-memberships]' do
        assert_select 'li', { text: /#{other_membership.artist.name}/, count: 0 }
      end
    end

    def test_get_show_for_other_user_displays_delete_actions_for_memberships
      membership = Membership.sham!( user: @other_user )
      get :show, :id => @other_user.to_param
      assert_select 'a[href=?][data-method=delete]', admin_membership_path( membership )
    end

    def test_get_show_for_other_user_displays_form_to_add_membership
      get :show, :id => @other_user.to_param
      assert_select 'form' do
        assert_select 'label', I18n.t( 'helpers.label.membership.artist_id' )
        assert_select 'select[name=?]', 'membership[artist_id]'
        assert_select 'input[type=hidden][name=?]', 'membership[user_id]'
      end
    end

    def test_get_show_for_other_user_displays_on_form_only_artist_user_is_not_member_of
      membership = Membership.sham!( user: @other_user )
      artist = Artist.sham!
      get :show, :id => @other_user.to_param
      assert_select 'form' do
        assert_select 'select[name=?]', "membership[artist_id]" do
          assert_select 'option[value=?]', artist.id, artist.name
          assert_select 'option[value=?]', membership.artist.id, 0
        end
      end
    end

    def test_get_edit_for_other_user_succeeds
      get :edit, :id => @other_user.to_param
      assert_response :success
    end

    def test_get_edit_password_for_other_user_succeeds
      get :edit_password, :id => @other_user.to_param
      assert_response :success
    end

    def test_get_new_succeeds
      get :new
      assert_response :success
    end

    def test_get_new_displays_headers
      get :new
      assert_title I18n.t( 'helpers.title.user.new' ), I18n.t( 'helpers.title.user.index' )
      assert_headers I18n.t( 'helpers.title.user.index' ), I18n.t( 'helpers.title.user.new' )
    end

    def test_get_index_displays_headers
      get :index
      assert_select "title", build_title( I18n.t( 'helpers.title.user.index' ) )
      assert_select "h1", I18n.t( 'helpers.title.user.index' )
    end

    def test_get_edit_password_for_other_user_displays_headers
      get :edit_password, :id => @other_user.to_param
      assert_title I18n.t( 'helpers.title.user.edit_password' ), @other_user.login,
        I18n.t( 'helpers.title.user.index' )
      assert_headers I18n.t( 'helpers.title.user.index' ), @other_user.login,
        I18n.t( 'helpers.title.user.edit_password' )
    end
  end
end

