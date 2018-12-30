# frozen_string_literal: true

class Admin::DraftsController < AdminController
  def index
    @album_presenters = AlbumPresenter.presenters_for(current_user.unpublished_albums)
  end
end
