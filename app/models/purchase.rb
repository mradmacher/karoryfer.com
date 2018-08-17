# frozen_string_literal: true

class Purchase < ActiveRecord::Base
  class PaymentError < StandardError
  end

  def self.create_payment(release)
    config_paypal(release.album.artist)
    paypal_payment = PayPal::SDK::REST::Payment.new({
      intent: 'sale',
      payer: { payment_method: 'paypal' },
      redirect_urls: {
        return_url: 'https://www.karoryfer.com',
        cancel_url: 'https://www.karoryfer.com'
      },
      transactions: [{
        item_list: {
          items: [{
            name: release.album.title,
            price: release.price,
            currency: release.currency,
            quantity: 1
          }]
        },
        amount: {
          total: release.price,
          currency: release.currency
        },
        description: release.album.artist.name
      }]
    })
    if paypal_payment.create
      paypal_payment.id
    else
      raise PaymentError, paypal_payment.error
    end
  end

  def self.execute_payment(release, payment_id, payer_id, ip)
    config_paypal(release.album.artist)
    paypal_payment = PayPal::SDK::REST::Payment.find(payment_id)
    paypal_payment.execute(payer_id: payer_id)
    Purchase.create(payment_id: payment_id, ip: ip, release_id: release.id)
  end

  def self.config_paypal(artist)
    PayPal::SDK::REST.set_config(
      mode: Rails.env.production? ? 'live' : 'sandbox',
      client_id: artist.paypal_id,
      client_secret: artist.paypal_secret
    )
  end
end
