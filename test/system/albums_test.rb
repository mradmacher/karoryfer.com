# frozen_string_literal: true

require 'application_system_test_case'

class AlbumViewTest < ApplicationSystemTestCase
  def setup
    @artist = Artist.sham!(reference: 'big-star')
    @album = Album.sham!(:published, artist: @artist, reference: 'the-best-of')
    @release = Release.sham!(album: @album, format: Release::FLAC)
  end

  def test_displays_proper_price
    @release.update(for_sale: true, price: 20.0, currency: 'USD')
    visit('/big-star/wydawnictwa/the-best-of')
    assert page.has_content?('20.00 USD')
  end

  def test_displays_proper_price_with_discount
    @release.update(for_sale: true, price: 20.0, currency: 'USD')
    @discount = Discount.create(release: @release, price: 10.0, currency: 'PLN', reference_id: 'super-offer')
    visit('/big-star/wydawnictwa/the-best-of?did=super-offer')
    assert page.has_content?('10.00 PLN')
  end
end
