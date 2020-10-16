# frozen_string_literal: true

require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  def test_get_index_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :index, params: { id: '1' }
    end
  end

  def test_get_show_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :show, params: { id: 'album' }
    end
  end

  def test_download_succeeds_if_release_in_provided_format_exists
    artist = Artist.sham!(reference: 'big-star')
    album = Album.sham!(:published, artist: artist, reference: 'the-best-of')
    Release.sham!(album: album, format: Release::FLAC, external_url: nil)

    get :download, params: { artist_id: 'big-star', id: 'the-best-of', download: 'flac' }
    assert_equal 'application/zip', response.headers['Content-Type']
    assert_match(/attachment/, response.headers['Content-Disposition'])
    assert_match(/big-star-the-best-of-flac\.zip/, response.headers['Content-Disposition'])
  end
end
