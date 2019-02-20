# frozen_string_literal: true

class PaypalsController < ApplicationController
  def show
    release = Release.find(params[:release_id])
    discount = Discount.where(reference_id: params[:did]).first if params.key?(:did)
    begin
      payment_id = PaymentService.new(release).create(discount)
      render json: { id: payment_id }
    rescue PaymentService::PaymentError => e
      render json: { error: e.message }
    end
  end

  def create
    release = Release.find(params[:release_id])
    purchase = PaymentService.new(release).execute(params[:paymentID], params[:payerID], request.remote_ip)
    flash[:purchased] = true
    if release.digital?
      flash[:purchase_url] = download_artist_album_url(release.album.artist, release.album, release.format, pid: purchase.reference_id)
    end
    render json: {
      success: true,
      redirect_url: artist_album_path(release.album.artist, release.album, pid: purchase.reference_id)
    }
  end
end
