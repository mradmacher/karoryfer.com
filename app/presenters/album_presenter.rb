# frozen_string_literal: true

class AlbumPresenter < Presenter
  def_delegators(:resource,
                 :title,
                 :published?,
                 :image?,
                 :image,
                 :license,
                 :year,
                 :donation,
                 :description,
                 :artist,
                 :attachments)

  alias album resource

  def price
    min_price_with_currency&.first
  end

  def currency
    min_price_with_currency&.last
  end

  def min_price_with_currency
    @min_price_with_currencty ||= releases.map { |r| [r.price, r.currency] }.select { |e| e.first }.sort_by(&:first).first
  end

  def path
    artist_album_path(album.artist, album)
  end

  def edit_path
    edit_admin_artist_album_path(album.artist, album)
  end

  def delete_path
    admin_artist_album_path(album.artist, album)
  end

  def free_releases
    releases.reject(&:for_sale?).reject(&:external?)
  end

  def external_releases
    releases.select(&:external?)
  end

  def paid_releases
    releases.select(&:for_sale?).map do |release_presenter|
      release_presenter.tap do |rp|
        rp.purchase_reference_id = purchase.reference_id if rp.id == purchase&.release_id
        rp.discount = discount if rp.id == discount&.release_id
      end
    end
  end

  def downloadable_releases
    @downloadable_releases = resource.releases.map { |r| ReleasePresenter.new(r) }
  end

  def download_path
    download_artist_album_path(album.artist, album)
  end

  def releases
    @releases = resource.releases.where(published: true).map { |r| ReleasePresenter.new(r) }
  end

  def tracks
    @tracks = TrackPresenter.presenters_for(resource.tracks)
  end

  attr_accessor :purchase, :discount
end
