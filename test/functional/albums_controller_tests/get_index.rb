module AlbumsControllerTests
  module GetIndex
    def test_get_index_for_guest_succeeds
      get :index
      assert_response :success
    end

    def test_get_index_for_guest_does_not_display_actions
      artist = Artist.sham!
      get :index, artist_id: artist.id
      assert_select 'a[href=?]', new_artist_album_path(artist), 0
    end

    def test_get_index_for_guest_does_not_display_unpublished
      5.times { Album.sham!( :published ) }
      5.times { Album.sham!( :unpublished ) }
      get :index
      Album.unpublished.each do |a|
        assert_select '*', { text: a.title, count: 0 }
      end
    end

    def test_get_index_for_guest_displays_published
      5.times { Album.sham!( :published ) }
      5.times { Album.sham!( :unpublished ) }
      get :index
      Album.published.each do |a|
        assert_select 'a', a.title
      end
    end

    def test_get_index_for_guest_in_artist_scope_displays_only_albums_for_artist
      artist = Artist.sham!
      for_artist = []
      not_for_artist = []
      5.times { for_artist << Album.sham!( :published, artist: artist ) }
      5.times { not_for_artist << Album.sham!( :published ) }
      get :index, artist_id: artist.to_param
      for_artist.each do |a|
        assert_select 'a', a.title
      end
      not_for_artist.each do |a|
        assert_select '*', { text: a.title, count: 0 }
      end
    end

    def test_get_index_for_guest_displays_headers
      get :index
      assert_select "title", build_title( I18n.t( 'helpers.title.album.index' ) )
      assert_select 'h1', I18n.t( 'helpers.title.album.index' )
    end

    def test_get_index_for_user_does_not_display_unpublished_albums
      login( User.sham! )
      5.times { Album.sham!( :unpublished ) }
      get :index
      Album.unpublished.each do |a|
        assert_select '*', { text: a.title, count: 0 }
      end
    end

    def test_get_index_for_artist_user_display_unpublished_albums_for_this_artist
      membership = Membership.sham!
      login( membership.user )
      artist = membership.artist
      for_artist = []
      not_for_artist = []
      5.times { for_artist << Album.sham!( :unpublished, artist: artist ) }
      5.times { not_for_artist << Album.sham!( :unpublished ) }
      get :index
      for_artist.each do |a|
        assert_select 'a', a.title
      end
      not_for_artist.each do |a|
        assert_select '*', { text: a.title, count: 0 }
      end
    end

    def test_get_index_for_user_in_artist_scope_does_not_show_actions
      artist = Artist.sham!
      login( User.sham! )
      get :index, artist_id: artist.id
      assert_select 'a[href=?]', new_artist_album_path(artist), 0
    end

    def test_get_index_for_artist_user_in_artist_scope_does_not_show_actions
      membership = Membership.sham!
      artist = membership.artist
      login( membership.user )
      get :index, artist_id: artist.id
      assert_select 'a[href=?]', new_artist_album_path(artist), 0
    end

    def test_get_index_for_admin_displays_unpublished
      login( User.sham!( :admin ) )
      5.times { Album.sham!( :published ) }
      5.times { Album.sham!( :unpublished ) }
      get :index
      Album.unpublished.each do |a|
        assert_select "a", a.title
      end
    end

    def test_get_index_for_admin_in_artist_scope_displays_actions
      artist = Artist.sham!
      login( User.sham!( :admin ) )
      get :index, artist_id: artist.to_param
      assert_select 'a[href=?]', new_artist_album_path(artist), I18n.t( 'helpers.action.album.new' )
    end
  end
end

