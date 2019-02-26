# frozen_string_literal: true

class PaypalsController < ApplicationController
  def show
    release = Release.find(params[:release_id])
    discount = Discount.where(reference_id: params[:did]).first if params.key?(:did)
    begin
      payment_id = Purchase.create_payment(release, discount)
      render json: { id: payment_id }
    rescue Purchase::PaymentError => e
      render json: { error: e.message }
    end
  end

  def create
    release = Release.find(params[:release_id])
    purchase = Purchase.execute_payment(release, params[:paymentID], params[:payerID], request.remote_ip)
    flash[:purchased] = true
    flash[:purchase_url] = download_artist_album_url(release.album.artist, release.album, release.format, pid: purchase.reference_id) if release.digital?
    render json: {
      success: true,
      redirect_url: artist_album_path(release.album.artist, release.album, pid: purchase.reference_id)
    }
  end
end
