# frozen_string_literal: true

class PayPalService
  def self.build_for(artist)
    self.new(artist.paypal_id, artist.paypal_secret, live: Rails.env.production?)
  end

  def initialize(service_id, service_secret, live: true)
    @live = live
    @service_id = service_id
    @service_secret = service_secret
    config_paypal
  end

  def create_payment(name:, price:, currency:, description:)
    paypal_payment = PayPal::SDK::REST::Payment.new(
      intent: 'sale',
      payer: { payment_method: 'paypal' },
      redirect_urls: {
        return_url: 'https://www.karoryfer.com',
        cancel_url: 'https://www.karoryfer.com'
      },
      transactions: [{
        item_list: {
          items: [{
            name: name,
            price: price,
            currency: currency,
            quantity: 1
          }]
        },
        amount: {
          total: price,
          currency: currency
        },
        description: description
      }]
    )
    raise PaymentService::PaymentError, paypal_payment.error unless paypal_payment.create
    paypal_payment.id
  end

  def execute_payment(payment_id:, payer_id:)
    paypal_payment = PayPal::SDK::REST::Payment.find(payment_id)
    paypal_payment.execute(payer_id: payer_id)
    paypal_payment.payer.payer_info
  end

  private

  attr_reader :service_id, :service_secret, :live

  def config_paypal
    PayPal::SDK::REST.set_config(
      mode: live ? 'live' : 'sandbox',
      client_id: service_id,
      client_secret: service_secret
    )
  end
end
