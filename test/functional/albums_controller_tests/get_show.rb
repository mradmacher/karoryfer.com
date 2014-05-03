module AlbumsControllerTests
  module GetShow
    def test_get_show_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        get :show, :id => 'album'
      end
    end

    def test_get_show_for_guest_succeeds
      album = Album.sham!( :published )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_response :success
    end

    def test_get_show_for_guest_is_denied_for_unpublished_album
      album = Album.sham!( :unpublished )
      assert_raises User::AccessDenied do
        get :show, :artist_id => album.artist.to_param, :id => album.to_param
      end
    end

    def test_get_show_for_guest_displays_headers
      album = Album.sham!( :published )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select "title", build_title( album.title, album.artist.name )
      assert_select 'h1', album.artist.name
      assert_select 'h2', album.title
    end

    def test_get_show_for_guest_does_not_display_actions
      album = Album.sham!( :published )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]', new_artist_album_path( album.artist ), 0
      assert_select 'a[href=?]', edit_artist_album_path( album.artist, album ), 0
      assert_select 'a[href=?][data-method=delete]', artist_album_path( album.artist, album ), 0
    end

    def test_get_show_for_user_is_denied_for_unpublished_album
      login( User.sham! )
      album = Album.sham!( :unpublished )
      assert_raises User::AccessDenied do
        get :show, :artist_id => album.artist.to_param, :id => album.to_param
      end
    end

    def test_get_show_for_artist_user_succeeds
      membership = Membership.sham!
      login( membership.user )
      album = Album.sham!( :unpublished, artist: membership.artist )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_response :success
    end

    def test_get_show_for_user_does_not_show_actions
      login( User.sham! )
      album = Album.sham!( :published )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]', new_artist_album_path( album.artist ), 0
      assert_select 'a[href=?]', edit_artist_album_path( album.artist, album ), 0
      assert_select 'a[href=?][data-method=delete]', artist_album_path( album.artist, album ), 0
    end

    def test_get_show_for_artist_user_does_not_show_actions
      membership = Membership.sham!
      login( membership.user )
      album = Album.sham!( :published, artist: membership.artist )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]', new_artist_album_path( album.artist ), 0
      assert_select 'a[href=?]', edit_artist_album_path( album.artist, album ), 0
      assert_select 'a[href=?][data-method=delete]', artist_album_path( album.artist, album ), 0
    end

    def test_get_show_for_admin_for_unpublished_succeeds
      login( User.sham!( :admin ) )
      album = Album.sham!( :unpublished )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_response :success
    end

    def test_get_show_for_admin_displays_actions
      login( User.sham!( :admin ) )
      album = Album.sham!
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]', edit_artist_album_path( album.artist ), I18n.t( 'action.edit' )
      #assert_select 'a[href=?][data-method=delete]', album_path( album ), I18n.t( 'action.album.destroy' )
      assert_select 'a[href=?][data-method=delete]', artist_album_path( album.artist, album ), 0
    end

    def test_get_show_displays_urls_to_attached_files
      album = Album.sham!( :published )
      att1 = album.attachments.create( file: File.open( File.join( FIXTURES_DIR, 'attachments', 'att1.jpg' ) ) )
      att2 = album.attachments.create( file: File.open( File.join( FIXTURES_DIR, 'attachments', 'att2.pdf' ) ) )
      att3 = album.attachments.create( file: File.open( File.join( FIXTURES_DIR, 'attachments', 'att3.txt' ) ) )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]',  att1.file.url, 'att1.jpg'
      assert_select 'a[href=?]',  att2.file.url, 'att2.pdf'
      assert_select 'a[href=?]',  att3.file.url, 'att3.txt'
    end
  end
end

