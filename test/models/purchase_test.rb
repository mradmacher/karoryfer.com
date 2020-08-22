# frozen_string_literal: true

require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  describe Purchase do
    before do
      @release = Release.sham!(external_url: 'http://you.want.to.get/me')
      @purchase = Purchase.sham!(release: @release)
    end

    describe '#downloads_exceeded?' do
      it 'is false by default' do
        refute @purchase.downloads_exceeded?
      end

      describe 'when download events count greater or equal to max downloads' do
        before do
          Purchase::MAX_DOWNLOADS.times { DownloadEvent.create(purchase_id: @purchase.id) }
        end

        it 'is true' do
          assert @purchase.downloads_exceeded?
        end
      end

      describe 'when download events count less than max downloads' do
        before do
          (Purchase::MAX_DOWNLOADS - 1).times { DownloadEvent.create(purchase_id: @purchase.id) }
        end

        it 'is true' do
          refute @purchase.downloads_exceeded?
        end
      end
    end

    describe '#presigned_url!' do
      describe 'when allows presigned url generation' do
        before do
          @purchase.update(generate_presigned_url: true)
        end

        it 'generates url using the passed signer' do
          signer = MiniTest::Mock.new
          signer.expect :generate_url, 'http://go.to.hell/please', ['http://you.want.to.get/me']
          assert_nil @purchase.presigned_url
          assert_nil @purchase.presigned_url_generated_at
          result = @purchase.presigned_url!(signer)
          assert_equal 'http://go.to.hell/please', result
          @purchase.reload
          assert_equal 'http://go.to.hell/please', @purchase.presigned_url
          refute_nil @purchase.presigned_url_generated_at
          signer.verify
        end
      end

      describe 'when does not allow presigned url generation' do
        before do
          @purchase.update(generate_presigned_url: false)
        end

        it 'returns nil and does nothing' do
          signer = MiniTest::Mock.new
          result = @purchase.presigned_url!(signer)
          assert_nil result
          @purchase.reload
          assert_nil @purchase.presigned_url
        end
      end
    end
  end
end
