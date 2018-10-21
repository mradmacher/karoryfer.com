# frozen_string_literal: true

require 'test_helper'

class AlbumDownloadTest < ActionDispatch::IntegrationTest
  def setup
    # Capybara.current_driver = :selenium_chrome_headless
    @artist = Artist.sham!(reference: 'big-star')
    @album = Album.sham!(:published, artist: @artist, reference: 'the-best-of')
    @release = Release.sham!(album: @album, format: Release::FLAC)
  end

  def test_download_fails_if_release_without_file
    @release.remove_file!
    @release.save
    refute @release.file?
    assert_equal 0, @release.downloads

    visit('/big-star/wydawnictwa/the-best-of/flac')
    assert_equal artist_album_path(@artist, @album), current_path
    assert_equal 0, @release.reload.downloads
  end

  def test_download_succeeds_if_release_in_provided_format_exists
    assert_equal 0, @release.downloads

    visit('/big-star/wydawnictwa/the-best-of')
    click_on('flac')
    assert_equal 'application/zip', page.response_headers['Content-Type']
    assert_match /attachment/, page.response_headers['Content-Disposition']
    assert_match /big-star-the-best-of-flac\.zip/, page.response_headers['Content-Disposition']
    assert_equal 1, @release.reload.downloads
  end

  def test_download_succeeds_with_purchase_code_if_release_for_sale
    @release.update(for_sale: true, price: 20.0, currency: 'USD')
    purchase = Purchase.create(release: @release, reference_id: 'xyz')
    assert_equal 0, purchase.downloads

    visit('/big-star/wydawnictwa/the-best-of/flac?pid=xyz')
    assert_equal 'application/zip', page.response_headers['Content-Type']
    assert_match /attachment/, page.response_headers['Content-Disposition']
    assert_match /big-star-the-best-of-flac\.zip/, page.response_headers['Content-Disposition']
    assert_equal 0, @release.reload.downloads
    assert_equal 1, purchase.reload.downloads
  end

  def test_download_fails_without_purchase_if_release_for_sale
    @release.update(for_sale: true, price: 20.0, currency: 'USD')

    visit('/big-star/wydawnictwa/the-best-of/flac')
    assert_equal artist_album_path(@artist, @album), current_path
    assert_equal 0, @release.reload.downloads
  end

  def test_download_fails_without_purchase_code_if_release_for_sale
    @release.update(for_sale: true, price: 20.0, currency: 'USD')
    Purchase.create(release: @release, reference_id: 'xyz')

    visit('/big-star/wydawnictwa/the-best-of/flac')
    assert_equal artist_album_path(@artist, @album), current_path
    assert_equal 0, @release.reload.downloads
  end

  def test_download_fails_when_download_limit_exceeded
    @release.update(for_sale: true, price: 20.0, currency: 'USD')
    purchase = Purchase.create(release: @release, reference_id: 'xyz', downloads: 6)

    visit('/big-star/wydawnictwa/the-best-of/flac?pid=xyz')
    assert_equal 7, purchase.reload.downloads

    visit('/big-star/wydawnictwa/the-best-of/flac?pid=xyz')
    assert_equal artist_album_path(@artist, @album), current_path
    assert page.has_content?('Limit pobrań został przekroczony.')
    assert_equal 7, purchase.reload.downloads
  end
end
