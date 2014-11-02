module AlbumsControllerTests
  module GetShow
    def test_get_show_without_artist_is_not_routable
      assert_raises ActionController::UrlGenerationError do
        get :show, :id => 'album'
      end
    end

    def test_authorized_get_show_succeeds
      album = Album.sham!
      allow(:read, album)
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_response :success
    end

    def test_authorized_get_show_displays_headers
      album = Album.sham!
      allow(:read, album)
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select "title", build_title( album.title, album.artist.name )
      assert_select 'h1', album.artist.name
      assert_select 'h2', album.title
    end

    def test_read_authorized_get_show_does_not_display_actions
      album = Album.sham!
      allow(:read, album)
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]', new_artist_album_path( album.artist ), 0
      assert_select 'a[href=?]', edit_artist_album_path( album.artist, album ), 0
      assert_select 'a[href=?][data-method=delete]', artist_album_path( album.artist, album ), 0
    end

    def test_write_authorized_get_show_displays_actions
      album = Album.sham!
      allow(:read, album)
      allow(:write, album)
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]', edit_artist_album_path(album.artist, album), I18n.t('action.edit')
      #assert_select 'a[href=?][data-method=delete]', album_path( album ), I18n.t( 'action.album.destroy' )
      assert_select 'a[href=?][data-method=delete]', artist_album_path( album.artist, album ), 0
    end

    def test_authorized_get_show_displays_urls_to_attached_files
      album = Album.sham!
      allow(:read, album)
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

