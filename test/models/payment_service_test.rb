# frozen_string_literal: true

require 'test_helper'

class PaymentServiceTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  def setup
    @artist = Artist.sham!(reference: 'big-star', name: 'Big Star')
    @album = Album.sham!(:published, artist: @artist, reference: 'the-best-of', title: 'The Best Of')
    @release = Release.sham!(album: @album, format: Release::FLAC, for_sale: true, price: 9.0, currency: 'USD')
    @service = Minitest::Mock.new
  end

  def test_creates_payment
    @service.expect :create_payment, 1, [name: 'The Best Of', price: 9, currency: 'USD', description: 'Big Star']
    assert_equal 1, PaymentService.new(@release, @service).create
    @service.verify
  end

  def test_raises_exception_when_creating_payment_fails
    def @service.create_payment(_)
      raise PaymentService::PaymentError
    end

    assert_raises PaymentService::PaymentError do
      PaymentService.new(@release, @service).create
    end
  end

  def test_applies_discount
    discount = Discount.create(release: @release, price: 5, currency: 'USD')
    @service.expect :create_payment, 1, [name: 'The Best Of', price: 5, currency: 'USD', description: 'Big Star']
    assert_equal 1, PaymentService.new(@release, @service).create(discount)
    @service.verify
  end

  def test_executes_payment
    payer_info = Minitest::Mock.new
    def payer_info.email
      'test@karoryfer.com'
    end
    def payer_info.first_name
      'Test'
    end
    @service.expect :execute_payment, payer_info, [payer_id: 1, payment_id: 2]

    purchase = PaymentService.new(@release, @service).execute(2, 1, '127.0.0.2')
    assert_equal @release, purchase.release
    assert_equal '127.0.0.2', purchase.ip
    assert_equal '2', purchase.payment_id
    @service.verify
  end

  def test_sends_confirmation
    def @service.execute_payment(_)
      payer_info = Minitest::Mock.new
      def payer_info.email
        'test@karoryfer.com'
      end
      def payer_info.first_name
        'Test'
      end
      payer_info
    end

    assert_enqueued_emails 1 do
      PaymentService.new(@release, @service).execute(2, 1, '127.0.0.2')
    end
  end
end
