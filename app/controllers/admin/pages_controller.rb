# frozen_string_literal: true

class Admin::PagesController < AdminController
  layout :set_layout

  def index
    @presenters = PagePresenter.presenters_for(current_artist.pages)
  end

  def edit
    @presenter = PagePresenter.new(find)
    render :edit
  end

  def new
    @presenter = PagePresenter.new(build)
    render :new
  end

  def update
    page = find.tap { |p| p.assign_attributes(page_params) }
    @presenter = PagePresenter.new(page)
    if page.save
      redirect_to @presenter.path
    else
      render :edit
    end
  end

  def create
    page = build.tap { |p| p.assign_attributes(page_params) }
    @presenter = PagePresenter.new(page)
    if page.save
      redirect_to @presenter.path
    else
      render :new
    end
  end

  def destroy
    find.destroy
    redirect_to artist_url(current_artist)
  end

  private

  def page_params
    params.require(:page).permit(
      :reference,
      :title_pl,
      :title_en,
      :content_pl,
      :content_en
    )
  end

  def find
    current_artist.pages.find_by_reference(params[:id])
  end

  def build
    current_artist.pages.new
  end
end
