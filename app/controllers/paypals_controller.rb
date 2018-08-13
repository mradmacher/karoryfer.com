# frozen_string_literal: true

class PaypalsController < ApplicationController
  def show
    release = Release.find(params[:release_id])
    begin
      payment_id = Purchase.create_payment(release)
      render json: { id: payment_id }
    rescue Purchase::PaymentError => e
      render json: { error: e.message }
    end
  end

  def create
    release = Release.find(params[:release_id])
    Purchase.execute_payment(release, params[:paymentID], params[:payerID], request.remote_ip)
    render json: { success: true }
  end
end
