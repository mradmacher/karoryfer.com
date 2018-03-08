# frozen_string_literal: true

class PagesController < CurrentArtistController
  layout :set_layout

  def index
    @presenters = PagePresenter.presenters_for(cruder.index)
  end

  def show
    @presenter = PagePresenter.new(cruder.show)
  end

  def edit
    @presenter = PagePresenter.new(cruder.edit)
    render :edit
  end

  def new
    @presenter = PagePresenter.new(cruder.new)
    render :new
  end

  def update
    redirect_to PagePresenter.new(cruder.update).path
  rescue Crudable::InvalidResource => e
    @presenter = PagePresenter.new(e.resource)
    render :edit
  end

  def create
    redirect_to PagePresenter.new(cruder.create).path
  rescue Crudable::InvalidResource => e
    @presenter = PagePresenter.new(e.resource)
    render :new
  end

  def destroy
    cruder.destroy
    redirect_to artist_url(current_artist)
  end

  private

  def policy_class
    PagePolicy
  end

  def cruder
    PageCruder.new(policy_class.new(current_user.resource), params, current_artist)
  end
end
