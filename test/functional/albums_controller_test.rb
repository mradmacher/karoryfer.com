require 'test_helper'

class Release
  def generate_in_background!
    self.file = File.open(File.join(FIXTURES_DIR, 'release.zip'))
    save
  end
end

class AlbumsControllerTest < ActionController::TestCase
  FIXTURES_DIR = File.expand_path('../../fixtures', __FILE__)

  def test_get_download_redirects_to_album_if_release_without_file_in_provided_format
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)
    release.remove_file!
    refute release.file?
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_redirected_to artist_album_url(album.artist, album)
  end

  def test_xhr_get_download_returns_false_if_release_without_file_in_provided_format
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)
    release.remove_file!
    refute release.file?
    xhr :get, :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal false, result['success']
  end

  def test_get_download_redirects_to_release_url_if_release_in_provided_format_exists
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_redirected_to release.file.url
  end

  def test_xhr_get_download_returns_release_url_if_release_in_provided_format_exists
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)
    xhr :get, :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_response :success

    result = JSON.parse(response.body)
    assert_equal true, result['success']
    assert_equal release.file.url, result['url']
  end

  def test_get_download_generates_release_for_release_without_file
    track = Track.sham! file: File.open(File.join(FIXTURES_DIR, 'tracks', '1.wav'))
    album = track.album
    release = Release.sham!(album: album, format: Release::FLAC, file: nil)

    refute release.file?
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert release.file?
  end

  def test_get_download_does_not_generate_release_if_file_exists
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)

    was_updated_at = release.updated_at
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_equal was_updated_at.to_i, release.updated_at.to_i
  end

  def test_get_download_does_not_generate_release_if_already_generated_for_provided_format
    skip 'This is a test for Release#generate_in_background!'
  end

  def test_get_download_does_not_change_counter_if_release_without_file_in_provided_format
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)
    release.remove_file!
    refute release.file?
    assert_equal 0, release.downloads
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_equal 0, release.downloads
  end

  def test_xhr_get_download_does_not_change_counter_if_release_without_file_in_provided_format
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)
    release.remove_file!
    refute release.file?
    assert_equal 0, release.downloads
    xhr :get, :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_equal 0, release.downloads
  end

  def test_get_download_increments_counter_if_release_in_provided_format_exists
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)
    assert release.file?
    assert_equal 0, release.downloads
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_equal 1, release.downloads
  end

  def test_xhr_get_download_increments_counter_if_release_in_provided_format_exists
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)
    assert release.file?
    assert_equal 0, release.downloads
    xhr :get, :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_equal 1, release.downloads
  end

  def test_delete_destroy_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      delete :destroy, id: 1
    end
  end

  def test_authorized_delete_destroy_properly_redirects
    album = Album.sham!
    assert_authorized do
      delete :destroy, artist_id: album.artist.to_param, id: album.to_param
    end
    assert_redirected_to artist_albums_path(album.artist)
  end

  def test_get_edit_without_artist_is_not_routable
    assert_raise ActionController::UrlGenerationError do
      get :edit, id: '1'
    end
  end

  def test_authorized_get_edit_displays_headers
    album = Album.sham!
    assert_authorized do
      get :edit, artist_id: album.artist.to_param, id: album.to_param
    end
    assert_select 'title', build_title(album.title, album.artist.name)
    assert_select 'h1', album.artist.name
    assert_select 'h2', album.title
  end

  def test_authorized_get_edit_displays_form
    album = Album.sham!
    assert_authorized do
      get :edit, artist_id: album.artist.to_param, id: album.to_param
    end
    assert_select 'form[enctype="multipart/form-data"]' do
      assert_select 'label', I18n.t('label.album.title')
      assert_select 'input[type=text][name=?][value=?]', 'album[title]', album.title
      assert_select 'label', I18n.t('label.album.published')
      assert_select 'label', I18n.t('label.album.year')
      assert_select 'input[type=number][name=?][value=?]', 'album[year]', album.year
      assert_select 'label', I18n.t('label.album.image')
      assert_select 'input[type=file][name=?]', 'album[image]'
      assert_select 'select[name=?]', 'album[license_id]' do
        assert_select 'option[value=?]', ''
        License.all.each do |license|
          if album.license == license
            assert_select 'option[value=?][selected=selected]', license.id, license.name
          else
            assert_select 'option[value=?][selected=selected]', license.id, 0
            assert_select 'option[value=?]', license.id, license.name
          end
        end
      end
      assert_select 'label', I18n.t('label.album.donation')
      assert_select 'textarea[name=?]', 'album[donation]', album.donation
      assert_select 'label', I18n.t('label.album.description')
      assert_select 'textarea[name=?]', 'album[description]', album.description
      assert_select 'button[type=submit]'
    end
  end

  def test_get_index_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :index, id: '1'
    end
  end

  def test_get_index_not_authorized_does_not_display_actions
    artist = Artist.sham!
    assert_authorized do
      get :index, artist_id: artist.to_param
    end
    assert_select 'a[href=?]', new_artist_album_path(artist), 0
  end

  def test_get_index_authorized_displays_actions
    artist = Artist.sham!
    assert_authorized do
      @controller.current_user.stub(:can_create_album?, true) do
        get :index, artist_id: artist.to_param
      end
    end
    assert_select 'a[href=?]', new_artist_album_path(artist), I18n.t('action.new')
  end

  def test_get_index_for_guest_does_not_display_unpublished
    artist = Artist.sham!
    2.times { Album.sham!(:published, artist: artist) }
    2.times { Album.sham!(:unpublished, artist: artist) }
    assert_authorized do
      get :index, artist_id: artist.to_param
    end
    Album.unpublished.each do |a|
      assert_select '*', text: a.title, count: 0
    end
  end

  def test_get_index_for_guest_displays_published
    artist = Artist.sham!
    2.times { Album.sham!(:published, artist: artist) }
    2.times { Album.sham!(:unpublished, artist: artist) }
    assert_authorized do
      get :index, artist_id: artist.to_param
    end
    Album.published.each do |a|
      assert_select 'a', a.title
    end
  end

  def test_get_index_for_guest_displays_only_albums_for_artist
    artist = Artist.sham!
    for_artist = []
    not_for_artist = []
    5.times { for_artist << Album.sham!(:published, artist: artist) }
    5.times { not_for_artist << Album.sham!(:published) }
    assert_authorized do
      get :index, artist_id: artist.to_param
    end
    for_artist.each do |a|
      assert_select 'a', a.title
    end
    not_for_artist.each do |a|
      assert_select '*', text: a.title, count: 0
    end
  end

  def test_get_index_for_user_does_not_display_unpublished_albums
    login_user
    artist = Artist.sham!
    3.times { Album.sham!(:unpublished, artist: artist) }
    assert_authorized do
      get :index, artist_id: artist.to_param
    end
    Album.unpublished.each do |a|
      assert_select '*', text: a.title, count: 0
    end
  end

  def test_authorized_get_new_displays_headers
    artist = Artist.sham!
    assert_authorized do
      get :new, artist_id: artist.to_param
    end
    title = CGI.escape_html(build_title(I18n.t('title.album.new'), artist.name))
    assert_select 'title', title, artist.name
    assert_select 'h1', artist.name
    assert_select 'h2', CGI.escape_html(I18n.t('title.album.new'))
  end

  def test_authorized_get_new_displays_form
    artist = Artist.sham!
    assert_authorized do
      get :new, artist_id: artist.to_param
    end
    assert_select 'form[enctype="multipart/form-data"]' do
      assert_select 'label', I18n.t('label.album.title')
      assert_select 'input[type=text][name=?]', 'album[title]'
      assert_select 'label', I18n.t('label.album.published')
      assert_select 'label', I18n.t('label.album.year')
      assert_select 'input[type=number][name=?]', 'album[year]'
      assert_select 'label', I18n.t('label.album.image')
      assert_select 'input[type=file][name=?]', 'album[image]'
      assert_select 'select[name=?]', 'album[license_id]' do
        assert_select 'option[value=?]', ''
        License.all.each do |license|
          assert_select 'option[value=?]', license.id, license.name
        end
      end
      assert_select 'label', I18n.t('label.album.donation')
      assert_select 'textarea[name=?]', 'album[donation]'
      assert_select 'label', I18n.t('label.album.description')
      assert_select 'textarea[name=?]', 'album[description]'
      assert_select 'button[type=submit]'
    end
  end

  def test_authorized_get_new_displays_actions
    artist = Artist.sham!
    assert_authorized do
      get :new, artist_id: artist.to_param
    end
    assert_select 'a[href=?]', artist_path(artist), I18n.t('action.cancel_new')
  end

  def test_get_show_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :show, id: 'album'
    end
  end

  def test_authorized_get_show_displays_headers
    album = Album.sham!
    assert_authorized do
      get :show, artist_id: album.artist.to_param, id: album.to_param
    end
    assert_select 'title', build_title(album.title, album.artist.name)
    assert_select 'h1', album.artist.name
    assert_select 'h2', album.title
  end

  def test_authorized_get_show_displays_urls_to_attached_files
    album = Album.sham!
    att1 = album.attachments.create(file: File.open(File.join(FIXTURES_DIR, 'attachments', 'att1.jpg')))
    att2 = album.attachments.create(file: File.open(File.join(FIXTURES_DIR, 'attachments', 'att2.pdf')))
    att3 = album.attachments.create(file: File.open(File.join(FIXTURES_DIR, 'attachments', 'att3.txt')))
    assert_authorized do
      get :show, artist_id: album.artist.to_param, id: album.to_param
    end
    assert_select 'a[href=?]',  att1.file.url, 'att1.jpg'
    assert_select 'a[href=?]',  att2.file.url, 'att2.pdf'
    assert_select 'a[href=?]',  att3.file.url, 'att3.txt'
  end

  def test_post_create_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      post :create, album: {}
    end
  end

  def test_put_update_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      put :update, id: 1, album: {}
    end
  end
end
