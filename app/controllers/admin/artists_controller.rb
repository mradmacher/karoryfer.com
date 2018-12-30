# frozen_string_literal: true

class Admin::ArtistsController < AdminController
  layout 'current_artist', except: %i[index new create]

  def edit
    @presenter = ArtistPresenter.new(find)
    render :edit
  end

  def new
    @presenter = ArtistPresenter.new(build)
    render :new
  end

  def update
    artist = find.tap { |a| a.assign_attributes(artist_params) }
    @presenter = ArtistPresenter.new(artist)
    if artist.save
      redirect_to @presenter.path
    else
      render :edit
    end
  end

  def create
    artist = build.tap { |a| a.assign_attributes(artist_params) }
    @presenter = ArtistPresenter.new(artist)
    if artist.save
      redirect_to @presenter.path
    else
      render :new
    end
  end

  private

  def artist_params
    params.require(:artist).permit(
      :name,
      :reference,
      :summary_pl,
      :summary_en,
      :image,
      :remove_image,
      :description_pl,
      :description_en
    )
  end

  def find
    Artist.find_by_reference(params[:id])
  end

  def build
    Artist.new
  end
end

