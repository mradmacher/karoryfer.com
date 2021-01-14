# frozen_string_literal: true

class PurchaseMailer < ApplicationMailer
  def confirmation(release, reference_id)
    @name = params[:name]
    @email = params[:email]
    if release.digital?
      @download_url = download_artist_album_url(release.album.artist, release.album, pid: reference_id)
    end
    @contact_email = release.album.artist.contact_email
    mail(to: @email, subject: "#{release.album.artist.name} - #{release.album.title}")
  end
end
