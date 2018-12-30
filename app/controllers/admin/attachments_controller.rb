# frozen_string_literal: true

class Admin::AttachmentsController < CurrentAlbumController
  layout :set_layout

  def index
    @presenter = AttachmentPresenter.new(build)
    @presenters = AttachmentPresenter.presenters_for(current_album.attachments)
  end

  def create
    attachment = build.tap { |t| t.assign_attributes(attachment_params) }
    attachment.save
    redirect_to admin_artist_album_attachments_url(current_artist, current_album)
  end

  def destroy
    find.destroy
    redirect_to admin_artist_album_attachments_url(current_artist, current_album)
  end

  private

  def find
    current_album.attachments.find(params[:id])
  end

  def build
    current_album.attachments.new
  end

  def attachment_params
    params.require(:attachment).permit(:file)
  end
end
