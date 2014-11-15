module AlbumsControllerTests
  module GetIndex
    def test_get_index_without_artist_is_not_routable
      assert_raises ActionController::UrlGenerationError do
        get :index, :id => '1'
      end
    end

    def test_get_index_not_authorized_does_not_display_actions
      artist = Artist.sham!
      allow(:read, Album, artist)
      get :index, artist_id: artist.to_param
      assert_select 'a[href=?]', new_artist_album_path(artist), 0
    end

    def test_get_index_authorized_displays_actions
      artist = Artist.sham!
      allow(:write, Album, artist)
      allow(:read, Album, artist)
      get :index, artist_id: artist.to_param
      assert_select 'a[href=?]', new_artist_album_path(artist), I18n.t( 'action.new' )
    end

    def test_get_index_for_guest_does_not_display_unpublished
      artist = Artist.sham!
      allow(:read, Album, artist)
      2.times { Album.sham!( :published, artist: artist ) }
      2.times { Album.sham!( :unpublished, artist: artist ) }
      get :index, artist_id: artist.to_param
      Album.unpublished.each do |a|
        assert_select '*', { text: a.title, count: 0 }
      end
    end

    def test_get_index_for_guest_displays_published
      artist = Artist.sham!
      allow(:read, Album, artist)
      2.times { Album.sham!( :published, artist: artist ) }
      2.times { Album.sham!( :unpublished, artist: artist ) }
      get :index, artist_id: artist.to_param
      Album.published.each do |a|
        assert_select 'a', a.title
      end
    end

    def test_get_index_for_guest_displays_only_albums_for_artist
      artist = Artist.sham!
      allow(:read, Album, artist)
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

    def test_get_index_for_user_does_not_display_unpublished_albums
      login_user
      artist = Artist.sham!
      allow(:read, Album, artist)
      3.times { Album.sham!( :unpublished, artist: artist ) }
      get :index, artist_id: artist.to_param
      Album.unpublished.each do |a|
        assert_select '*', { text: a.title, count: 0 }
      end
    end
  end
end
