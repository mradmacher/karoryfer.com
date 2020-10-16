# frozen_string_literal: true

require 'application_system_test_case'

class AlbumDownloadsTest < ApplicationSystemTestCase
  def setup
    @artist = Artist.sham!(reference: 'big-star')
    @album = Album.sham!(:published, artist: @artist, reference: 'the-best-of')
    @release = Release.sham!(album: @album, format: Release::FLAC)
  end

  def test_download_suceeds_for_external_url
    refute @release.external_url.blank?
    assert_equal 0, @release.download_events.count

    visit('/big-star/wydawnictwa/the-best-of/flac')
    assert_equal 1, @release.reload.download_events.count
  end

  def test_download_suceeds_for_file
    @release.update(external_url: nil)
    assert @release.external_url.blank?
    assert @release.file?
    assert_equal 0, @release.download_events.count

    visit('/big-star/wydawnictwa/the-best-of/flac')
    assert_equal 1, @release.reload.download_events.count
  end

  def test_download_succeeds_when_clicking_on_release_button
    assert_equal 0, @release.download_events.count

    visit('/big-star/wydawnictwa/the-best-of')
    click_on('flac')
    assert_equal 1, @release.reload.download_events.count
  end

  def test_download_succeeds_with_purchase_code_if_release_for_sale
    @release.update(for_sale: true, price: 20.0, currency: 'USD')
    purchase = Purchase.create(release: @release, reference_id: 'xyz')
    assert_equal 0, purchase.download_events.count

    visit('/big-star/wydawnictwa/the-best-of/flac?pid=xyz')
    assert_equal 1, @release.reload.download_events.count
    assert_equal 1, purchase.reload.download_events.count
  end

  def test_download_fails_without_purchase_if_release_for_sale
    @release.update(for_sale: true, price: 20.0, currency: 'USD')

    visit('/big-star/wydawnictwa/the-best-of/flac')
    assert_equal artist_album_path(@artist, @album), current_path
    assert_equal 0, @release.download_events.count
  end

  def test_download_fails_without_purchase_code_if_release_for_sale
    @release.update(for_sale: true, price: 20.0, currency: 'USD')
    Purchase.create(release: @release, reference_id: 'xyz')

    visit('/big-star/wydawnictwa/the-best-of/flac')
    assert_equal artist_album_path(@artist, @album), current_path
    assert_equal 0, @release.reload.download_events.count
  end

  def test_download_fails_when_download_limit_exceeded
    @release.update(for_sale: true, price: 20.0, currency: 'USD')
    purchase = Purchase.create(release: @release, reference_id: 'xyz')
    20.times { DownloadEvent.create(purchase: purchase, release: @release, created_at: Time.now) }

    visit('/big-star/wydawnictwa/the-best-of/flac?pid=xyz&l=pl')
    assert_equal artist_album_path(@artist, @album), current_path
    assert_equal 20, purchase.reload.download_events.count
    assert page.has_content?('Limit pobrań został przekroczony.')
  end
end
