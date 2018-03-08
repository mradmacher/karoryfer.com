# frozen_string_literal: true

class AttachmentsController < CurrentAlbumController
  layout :set_layout

  def index
    @presenter = AttachmentPresenter.new(cruder.new)
    @presenters = AttachmentPresenter.presenters_for(cruder.index)
  end

  def show
    redirect_to cruder.show.file.url
  end

  def edit
    @presenter = AttachmentPresenter.new(cruder.edit)
    render :edit
  end

  def new
    @presenter = AttachmentPresenter.new(cruder.new)
    render :new
  end

  def create
    cruder.create
    redirect_to artist_album_attachments_url(current_artist, current_album)
  rescue Crudable::InvalidResource => e
    @presenter = AttachmentPresenter.new(e.resource)
    render :new
  end

  def destroy
    cruder.destroy
    redirect_to artist_album_attachments_url(current_artist, current_album)
  end

  private

  def policy_class
    AttachmentPolicy
  end

  def cruder
    AttachmentCruder.new(policy_class.new(current_user.resource), params, current_album)
  end
end
