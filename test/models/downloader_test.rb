# frozen_string_literal: true

require 'test_helper'

class DownloaderTest < ActiveSupport::TestCase
  describe Downloader do
    before do
      @artist = Artist.sham!(reference: 'big-star')
      @album = Album.sham!(:published, artist: @artist, reference: 'the-best-of')
      @release = Release.sham!(album: @album, format: Release::FLAC)
    end

    it 'return nil if release in provided format does not exist' do
      assert_equal 0, @release.download_events.count

      result = Downloader.new(@album).download(release_format: Release::MP3)
      assert_nil result
      assert_equal 0, @release.reload.download_events.count
    end

    it 'uses external url first' do
      refute @release.external_url.blank?
      assert @release.file?
      assert_equal 0, @release.download_events.count

      result = Downloader.new(@album).download(release_format: Release::FLAC)
      assert_equal 1, @release.reload.download_events.count
      assert_equal @release.external_url, result
    end

    it 'uses file if no external url' do
      @release.update(external_url: nil)
      assert @release.external_url.blank?
      assert @release.file?
      assert_equal 0, @release.download_events.count

      result = Downloader.new(@album).download(release_format: Release::FLAC)
      assert_equal 1, @release.reload.download_events.count
      assert result.is_a?(Uploader::Release)
      assert_equal @release.file.path, result.path
    end

    it 'succeeds with purchase code if release for sale' do
      @release.update(for_sale: true, price: 20.0, currency: 'USD')
      purchase = Purchase.create(release: @release, reference_id: 'xyz')
      assert_equal 0, purchase.download_events.count

      result = Downloader.new(@album).download(release_format: Release::FLAC, purchase_reference: 'xyz')
      assert_equal 1, @release.reload.download_events.count
      assert_equal 1, purchase.reload.download_events.count
      assert_equal @release.external_url, result
    end

    describe 'if release for sale' do
      before do
        @release.update(for_sale: true, price: 20.0, currency: 'USD')
      end

      it 'fails if no purchase' do
        assert_raises Downloader::NotPurchasedError do
          Downloader.new(@album).download(release_format: Release::FLAC)
        end
        assert_equal 0, @release.download_events.count
      end

      it 'fails if purchase exists but not provided' do
        @release.update(for_sale: true, price: 20.0, currency: 'USD')
        Purchase.create(release: @release, reference_id: 'xyz')

        assert_raises Downloader::NotPurchasedError do
          Downloader.new(@album).download(release_format: Release::FLAC)
        end
        assert_equal 0, @release.reload.download_events.count
      end

      it 'fails if purchase exists but wrong code provided' do
        @release.update(for_sale: true, price: 20.0, currency: 'USD')
        Purchase.create(release: @release, reference_id: 'abc')

        assert_raises Downloader::NotPurchasedError do
          Downloader.new(@album).download(release_format: Release::FLAC)
        end
        assert_equal 0, @release.reload.download_events.count
      end
    end

    it 'fails when download limit exceeded' do
      @release.update(for_sale: true, price: 20.0, currency: 'USD')
      purchase = Purchase.create(release: @release, reference_id: 'xyz')
      20.times { DownloadEvent.create(purchase: purchase, release: @release, created_at: Time.now) }

      assert_raises Downloader::DownloadsExceededError do
        Downloader.new(@album).download(release_format: Release::FLAC, purchase_reference: 'xyz')
      end
      assert_equal 20, purchase.reload.download_events.count
    end
  end
end
