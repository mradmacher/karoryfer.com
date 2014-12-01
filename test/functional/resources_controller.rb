module ResourcesController
  def test_delete_destroy_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      delete :destroy, id: resource_class.sham!.to_param
    end
  end

  def test_delete_destroy_for_artist_user_properly_redirects
    membership = login_artist_user
    resource = resource_class.sham!( artist: membership.artist )
    delete :destroy, artist_id: resource.artist.to_param, id: resource.to_param
    assert_redirected_to send( "artist_#{resource_name.pluralize}_path",  resource.artist )
  end

  def test_get_edit_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :edit, :id => resource_class.sham!.to_param
    end
  end

  def test_get_edit_for_artist_user_displays_headers
    membership = login_artist_user
    resource = resource_class.sham!( artist: membership.artist )
    get :edit, artist_id: resource.artist.to_param, id: resource.to_param
    assert_select "title", build_title( resource.title, resource.artist.name )
    assert_select "h1", resource.artist.name
    assert_select "h2", resource.title
  end

  def test_get_index_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :index
    end
  end

  def test_get_index_for_guest_does_not_display_actions
    artist = Artist.sham!
    get :index, artist_id: artist.to_param
    assert_select 'a[href=?]', send("new_artist_#{resource_name}_path", artist), 0
  end

  def test_get_index_for_user_does_not_display_actions
    artist = Artist.sham!
    login_user
    get :index, artist_id: artist.to_param
    assert_select 'a[href=?]', send("new_artist_#{resource_name}_path", artist), 0
  end

  def test_get_index_for_artist_user_displays_actions
    membership = login_artist_user
    get :index, artist_id: membership.artist.to_param
    assert_select 'a[href=?]', send("new_artist_#{resource_name}_path", membership.artist ),
      I18n.t( "action.new" )
  end

  def test_get_index_for_guest_displays_resources_only_for_given_artist
    expected = []
    other = []
    artist = Artist.sham!
    5.times{ expected << resource_class.sham!( artist: artist ) }
    5.times{ other << resource_class.sham! }
    get :index, artist_id: artist.to_param
    expected.each do |r|
      assert_select "a", r.title
    end
    other.each do |r|
      assert_select "a", {text: r.title, count: 0}
    end
  end

  def test_get_new_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :new
    end
  end

  def test_get_new_for_artist_user_displays_headers
    membership = login_artist_user
    get :new, artist_id: membership.artist.to_param
    assert_select "title", CGI.escape_html( build_title( I18n.t( "title.#{resource_name}.new" ), membership.artist.name ) )
    assert_select "h1", membership.artist.name
    assert_select "h2", CGI.escape_html( I18n.t( "title.#{resource_name}.new" ) )
  end

  def test_get_edit_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :show, :id => resource_class.sham!.to_param
    end
  end

  def test_get_show_for_guest_displays_headers
    resource = resource_class.sham!
    get :show, artist_id: resource.artist.to_param, id: resource.to_param
    assert_select "title", build_title( resource.title, resource.artist.name )
    assert_select 'h1', resource.artist.name
    assert_select 'h2', resource.title
  end

  def test_post_create_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      post :create, resource_name.to_sym => {}
    end
  end

  def test_put_update_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      put :update, id: resource_class.sham!.id, resource_name.to_sym => {}
    end
  end
end
