# frozen_string_literal: true

class PagesController < CurrentArtistController
  layout :set_layout

  def show
    @presenter = PagePresenter.new(find)
  end

  private

  def find
    current_artist.pages.find_by_reference(params[:id])
  end
end
