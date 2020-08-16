# frozen_string_literal: true

class PaymentService
  class PaymentError < StandardError; end

  attr_reader :release

  def initialize(release, provider = nil)
    @release = release
    @provider = provider || PayPalService.build_for(artist)
  end

  def create(discount = nil)
    price, currency = release.price_and_currency(discount)
    provider.create_payment(name: album.title, price: price, currency: currency, description: artist.name)
  end

  def execute(payment_id, payer_id, ip)
    payer_info = provider.execute_payment(payment_id: payment_id, payer_id: payer_id)
    Purchase.create(payment_id: payment_id, ip: ip, release_id: release.id).tap do |purchase|
      send_confirmation(purchase, payer_info)
    end
  end

  private

  attr_reader :provider

  def artist
    release.album.artist
  end

  def album
    release.album
  end

  def send_confirmation(purchase, payer_info)
    PurchaseMailer.with(
      email: payer_info.email,
      name: payer_info.first_name
    ).confirmation(purchase.release, purchase.reference_id).deliver_later
  end
end
