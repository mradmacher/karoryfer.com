# frozen_string_literal: true

require 'test_helper'

class ArtistViewTest < ActionDispatch::IntegrationTest
  def test_get_show_succeeds
    artist = Artist.sham!(reference: 'a-real-star', name: 'A Real Star')
    visit('/a-real-star')
    assert_equal artist_path(artist), current_path
    assert page.has_content?('A Real Star')
  end
end
