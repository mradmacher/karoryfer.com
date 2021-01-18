# frozen_string_literal: true

require 'test_helper'

class DownloaderTest < ActiveSupport::TestCase
  describe Downloader do
    before do
      @artist = Artist.sham!(reference: 'big-star')
      @album = Album.sham!(:published, artist: @artist, reference: 'the-best-of')
      @release = Release.sham!(album: @album, format: Release::FLAC)
      @downloader = Downloader.new(@album)
    end

    describe '#free_download' do
      it 'retuns some release if format not provided' do
        assert_equal 0, @release.download_events.count

        result = @downloader.free_download(nil)
        refute_nil result
        assert_equal 1, @release.reload.download_events.count
      end

      it 'return nil if release in provided format does not exist' do
        assert_equal 0, @release.download_events.count

        result = @downloader.free_download(Release::MP3)
        assert_nil result
        assert_equal 0, @release.reload.download_events.count
      end

      it 'uses external url first' do
        refute @release.external_url.blank?
        assert @release.file?
        assert_equal 0, @release.download_events.count

        result = @downloader.free_download(Release::FLAC)
        assert_equal 1, @release.reload.download_events.count
        assert_equal @release.external_url, result
        assert_equal @release.external_url, @release.download_events.first.source
      end

      it 'uses file if no external url' do
        @release.update(external_url: nil)
        assert @release.external_url.blank?
        assert @release.file?
        assert_equal 0, @release.download_events.count

        result = @downloader.free_download(Release::FLAC)
        assert_equal 1, @release.reload.download_events.count
        assert result.is_a?(Uploader::Release)
        assert_equal @release.file.path, result.path
        assert_equal 'big-star-the-best-of-flac.zip', @release.download_events.first.source
      end

      it 'returns nothing for release for sale' do
        @release.update(for_sale: true, price: 20.0, currency: 'USD')
        result = @downloader.free_download(Release::FLAC)
        assert_nil result
        assert_equal 0, @release.download_events.count
      end
    end

    describe '#purchased_download' do
      it 'succeeds with correct purchase code' do
        @release.update(for_sale: true, price: 20.0, currency: 'USD')
        purchase = Purchase.create(release: @release, reference_id: 'xyz')
        assert_equal 0, purchase.download_events.count

        result = @downloader.purchased_download('xyz')
        assert_equal 1, @release.reload.download_events.count
        assert_equal 1, purchase.reload.download_events.count
        assert_equal @release.external_url, result
        assert_equal @release.external_url, @release.download_events.first.source
      end

      it 'succeeds with correct purchase code when presigned url' do
        @release.update(for_sale: true, price: 20.0, currency: 'USD')
        purchase = Purchase.create(release: @release, reference_id: 'xyz', presigned_url: 'https://somewhere.in.the.world')
        assert_equal 0, purchase.download_events.count

        result = @downloader.purchased_download('xyz')
        assert_equal 1, @release.reload.download_events.count
        assert_equal 1, purchase.reload.download_events.count
        assert_equal 'https://somewhere.in.the.world', @release.download_events.first.source
      end

      it 'fails if purchase exists but not provided' do
        @release.update(for_sale: true, price: 20.0, currency: 'USD')
        Purchase.create(release: @release, reference_id: 'xyz')

        assert_raises Downloader::NotPurchasedError do
          @downloader.purchased_download(nil)
        end
        assert_equal 0, @release.reload.download_events.count
      end

      it 'fails if purchase exists but wrong code provided' do
        @release.update(for_sale: true, price: 20.0, currency: 'USD')
        Purchase.create(release: @release, reference_id: 'abc')

        assert_raises Downloader::NotPurchasedError do
          @downloader.purchased_download('xyz')
        end
        assert_equal 0, @release.reload.download_events.count
      end
    end

    it 'fails when download limit exceeded' do
      @release.update(for_sale: true, price: 20.0, currency: 'USD')
      purchase = Purchase.create(release: @release, reference_id: 'xyz')
      20.times { DownloadEvent.create(purchase: purchase, release: @release, created_at: Time.now) }

      assert_raises Downloader::DownloadsExceededError do
        @downloader.purchased_download('xyz')
      end
      assert_equal 20, purchase.reload.download_events.count
    end
  end
end
