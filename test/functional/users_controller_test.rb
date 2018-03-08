# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def test_authorized_get_show_succeeds
    user = User.sham!
    assert_authorized do
      get :show, id: user.to_param
    end
    assert_response :success
  end

  def test_authorized_get_edit_succeeds
    user = User.sham!
    assert_authorized do
      get :edit, id: user.to_param
    end
    assert_response :success
  end

  def test_authorized_get_edit_password_succeeds
    user = User.sham!
    assert_authorized do
      get :edit_password, id: user.to_param
    end
    assert_response :success
  end

  def test_authorized_get_show_displays_headers
    user = User.sham!
    assert_authorized do
      get :show, id: user.to_param
    end
    assert_title user.login, I18n.t('title.user.index')
    assert_headers I18n.t('title.user.index'), user.login
  end

  def test_authorized_get_show_displays_memberships
    user = User.sham!
    memberships = []
    memberships << Membership.sham!(user: user)
    memberships << Membership.sham!(user: user)
    memberships << Membership.sham!(user: user)
    assert_authorized do
      get :show, id: user.to_param
    end
    memberships.each do |membership|
      assert_select 'li', membership.artist.name
    end
  end

  def test_not_authorized_get_show_does_not_displays_delete_actions_for_memberships
    user = User.sham!
    membership = Membership.sham!(user: user)
    assert_authorized do
      get :show, id: user.to_param
    end
    assert_select 'a[href=?][data-method=delete]', admin_user_membership_path(user, membership), 0
  end

  def test_authorized_get_show_displays_delete_actions_for_memberships
    user = User.sham!
    membership = Membership.sham!(user: user)
    assert_authorized do
      get :show, id: user.to_param
    end
    assert_select 'a[href=?][data-method=delete]', admin_user_membership_path(user, membership)
  end

  def test_authorized_get_edit_for_user_displays_headers
    user = User.sham!
    assert_authorized do
      get :edit, id: user.to_param
    end
    assert_title I18n.t('title.user.edit'), user.login, I18n.t('title.user.index')
    assert_headers I18n.t('title.user.index'), user.login, I18n.t('title.user.edit')
  end

  def test_get_edit_for_user_does_not_display_admin_field
    user = User.sham!
    assert_authorized do
      get :edit, id: user.to_param
    end
    assert_select 'form > input[name=?]', 'user[admin]', 0
  end

  def test_authorized_get_index_succeeds
    assert_authorized do
      get :index
    end
    assert_response :success
  end

  def test_authorized_get_show_displays_memberships_only_for_that_user
    user = User.sham!
    membership = Membership.sham!(user: user)
    other_membership = Membership.sham!
    assert_authorized do
      get :show, id: user.to_param
    end
    assert_select 'ul[class=user-memberships]' do
      assert_select 'li', text: /#{membership.artist.name}/, count: 1
      assert_select 'li', text: /#{other_membership.artist.name}/, count: 0
    end
  end

  def test_authorized_get_show_for_admin_displays_form_to_add_membership
    user = User.sham!
    assert_authorized do
      get :show, id: user.to_param
    end
    assert_select 'form' do
      assert_select 'label', I18n.t('label.membership.artist_id')
      assert_select 'select[name=?]', 'membership[artist_id]'
      assert_select 'input[type=hidden][name=?]', 'membership[user_id]'
    end
  end

  def test_authorized_get_show_for_admin_displays_on_form_only_artist_user_is_not_member_of
    user = User.sham!
    membership = Membership.sham!(user: user)
    artist = Artist.sham!
    assert_authorized do
      get :show, id: user.to_param
    end
    assert_select 'form' do
      assert_select 'select[name=?]', 'membership[artist_id]' do
        assert_select 'option[value=?]', artist.id, artist.name
        assert_select 'option[value=?]', membership.artist.id, 0
      end
    end
  end

  def test_authorized_get_new_succeeds
    assert_authorized do
      get :new
    end
    assert_response :success
  end

  def test_authorized_get_new_displays_headers
    assert_authorized do
      get :new
    end
    assert_title CGI.escape_html(I18n.t('title.user.new')), I18n.t('title.user.index')
    assert_headers I18n.t('title.user.index'), CGI.escape_html(I18n.t('title.user.new'))
  end

  def test_authorized_get_index_displays_headers
    assert_authorized do
      get :index
    end
    assert_select 'title', build_title(I18n.t('title.user.index'))
    assert_select 'h1', I18n.t('title.user.index')
  end

  def test_authorized_get_edit_password_displays_headers
    user = User.sham!
    assert_authorized do
      get :edit_password, id: user.to_param
    end
    assert_title I18n.t('title.user.edit_password'),
                 user.login,
                 I18n.t('title.user.index')
    assert_headers I18n.t('title.user.index'),
                   user.login,
                   I18n.t('title.user.edit_password')
  end
end
