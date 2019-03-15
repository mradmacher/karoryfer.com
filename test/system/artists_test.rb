# frozen_string_literal: true

require 'application_system_test_case'

class ArtistViewTest < ApplicationSystemTestCase
  def test_get_show_succeeds
    artist = Artist.sham!(reference: 'a-real-star', name: 'A Real Star')
    visit('/a-real-star')
    assert_equal artist_path(artist), current_path
    assert page.has_content?('A Real Star')
  end
end
