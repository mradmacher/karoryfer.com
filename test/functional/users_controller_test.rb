require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def test_get_index_is_authorized
    assert_authorized :read, User do
      get :index
    end
  end

  def test_get_edit_is_authorized
    user = User.sham!
    assert_authorized :write, user do
      get :edit, :id => user.to_param
    end
  end

  def test_get_edit_password_is_authorized
    user = User.sham!
    assert_authorized :write, user do
      get :edit_password, :id => user.to_param
    end
  end

  def test_get_new_is_authorized
    assert_authorized :write, User do
      get :new
    end
  end

  def test_get_show_is_authorized
    user = User.sham!
    assert_authorized :read, user do
      get :show, :id => user.to_param
    end
  end

  def test_delete_destroy_is_authorized
    user = User.sham!
    assert_authorized :write, user do
      delete :destroy, :id => user.to_param
    end
  end

  def test_post_create_is_authorized
    assert_authorized :write, User do
      post :create, :user => {}
    end
  end

  def test_put_update_is_authorized
    user = User.sham!
    assert_authorized :write, user do
      put :update, :id => user.to_param, :user => {a: 1}
    end
  end


  def test_authorized_get_show_succeeds
    user = User.sham!
    allow(:read,  user)
    get :show, :id => user.to_param
    assert_response :success
  end

  def test_authorized_get_edit_succeeds
    user = User.sham!
    allow(:write,  user)
    get :edit, :id => user.to_param
    assert_response :success
  end

  def test_authorized_get_edit_password_succeeds
    user = User.sham!
    allow(:write,  user)
    get :edit_password, :id => user.to_param
    assert_response :success
  end

  def test_authorized_get_show_displays_headers
    user = User.sham!
    allow(:read,  user)
    get :show, :id => user.to_param
    assert_title user.login, I18n.t( 'title.user.index' )
    assert_headers I18n.t( 'title.user.index' ), user.login
  end

  def test_authorized_get_show_displays_memberships
    user = User.sham!
    allow(:read,  user)
    memberships = []
    memberships << Membership.sham!( user: user )
    memberships << Membership.sham!( user: user )
    memberships << Membership.sham!( user: user )
    get :show, :id => user.to_param
    memberships.each do |membership|
      assert_select 'li', membership.artist.name
    end
  end

  def test_not_authorized_get_show_does_not_displays_delete_actions_for_memberships
    user = User.sham!
    allow(:read,  user)
    membership = Membership.sham!( user: user )
    get :show, :id => user.to_param
    assert_select 'a[href=?][data-method=delete]', admin_membership_path( membership ), 0
  end

  def test_authorized_get_show_displays_delete_actions_for_memberships
    user = User.sham!
    membership = Membership.sham!(user: user)
    allow(:read, user)
    allow(:write, membership)
    get :show, :id => user.to_param
    assert_select 'a[href=?][data-method=delete]', admin_membership_path(membership)
  end

  def test_authorized_get_edit_for_user_displays_headers
    user = User.sham!
    allow(:write,  user)
    get :edit, :id => user.to_param
    assert_title I18n.t( 'title.user.edit' ), user.login, I18n.t( 'title.user.index' )
    assert_headers I18n.t( 'title.user.index' ), user.login, I18n.t( 'title.user.edit' )
  end

  def test_authorized_get_edit_password_displays_headers
    user = User.sham!
    allow(:write,  user)
    get :edit_password, :id => user.to_param
    assert_title I18n.t( 'title.user.edit_password' ), user.login, I18n.t( 'title.user.index' )
    assert_headers I18n.t( 'title.user.index' ), user.login, I18n.t( 'title.user.edit_password' )
  end

  def test_get_edit_for_user_does_not_display_admin_field
    user = User.sham!
    allow(:write,  user)
    get :edit, :id => user.to_param
    assert_select 'form > input[name=?]', 'user[admin]', 0
  end


  def test_authorized_get_index_succeeds
    allow(:read, User)
    get :index
    assert_response :success
  end

  def test_authorized_get_show_displays_memberships_only_for_that_user
    user = User.sham!
    allow(:read, user)
    membership = Membership.sham!(user: user)
    other_membership = Membership.sham!
    get :show, :id => user.to_param
    assert_select 'ul[class=user-memberships]' do
      assert_select 'li', { text: /#{membership.artist.name}/, count: 1 }
      assert_select 'li', { text: /#{other_membership.artist.name}/, count: 0 }
    end
  end

  def test_authorized_get_show_for_admin_displays_form_to_add_membership
    user = User.sham!
    allow(:read, user)
    allow(:write, Membership, user)
    get :show, :id => user.to_param
    assert_select 'form' do
      assert_select 'label', I18n.t( 'label.membership.artist_id' )
      assert_select 'select[name=?]', 'membership[artist_id]'
      assert_select 'input[type=hidden][name=?]', 'membership[user_id]'
    end
  end

  def test_authorized_get_show_for_admin_displays_on_form_only_artist_user_is_not_member_of
    user = User.sham!
    allow(:read, user)
    allow(:write, Membership, user)
    membership = Membership.sham!(user: user)
    artist = Artist.sham!
    get :show, :id => user.to_param
    assert_select 'form' do
      assert_select 'select[name=?]', "membership[artist_id]" do
        assert_select 'option[value=?]', artist.id, artist.name
        assert_select 'option[value=?]', membership.artist.id, 0
      end
    end
  end

  def test_authorized_get_new_succeeds
    allow(:write, User)
    get :new
    assert_response :success
  end

  def test_authorized_get_new_displays_headers
    allow(:write, User)
    get :new
    assert_title CGI.escape_html( I18n.t( 'title.user.new' ) ), I18n.t( 'title.user.index' )
    assert_headers I18n.t( 'title.user.index' ), CGI.escape_html( I18n.t( 'title.user.new' ) )
  end

  def test_authorized_get_index_displays_headers
    allow(:read, User)
    get :index
    assert_select "title", build_title( I18n.t( 'title.user.index' ) )
    assert_select "h1", I18n.t( 'title.user.index' )
  end

  def test_authorized_get_edit_password_displays_headers
    user = User.sham!
    allow(:write, user)
    get :edit_password, :id => user.to_param
    assert_title I18n.t( 'title.user.edit_password' ), user.login,
      I18n.t( 'title.user.index' )
    assert_headers I18n.t( 'title.user.index' ), user.login,
      I18n.t( 'title.user.edit_password' )
  end


  def test_protects_admin_flag_from_mass_assignment
		user = User.sham!(admin: false)
    other_user = User.sham!(admin: false)
    allow(:write, other_user)
    put :update, id: other_user.to_param, user: {admin: true}
		refute other_user.admin?
	end

	def test_allows_mass_assignment_of_admin_flag_by_admin
		user = User.sham!(:admin)
    other_user = User.sham!(admin: false)
    allow(:write, other_user)
    login(user)
    put :update, id: other_user.to_param, user: {admin: true}
		assert other_user.admin?
	end

  def test_protects_publisher_flag_from_mass_assignment
		user = User.sham!(admin: false)
    other_user = User.sham!(publisher: false)
    allow(:write, other_user)
    put :update, :id => other_user.to_param, :user => {publisher: true}
		refute other_user.publisher?
	end

	def test_allows_mass_assignment_of_publisher_flag_by_admin
		user = User.sham!(:admin)
    other_user = User.sham!(publisher: false)
    allow(:write, other_user)
    put :update, :id => other_user.to_param, :user => {publisher: true}
		assert other_user.publisher?
	end
end

