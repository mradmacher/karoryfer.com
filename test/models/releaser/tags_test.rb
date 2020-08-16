# frozen_string_literal: true

require 'test_helper'

class TagsTest < ActiveSupport::TestCase
  def test_copyright_description
    @tags = Releaser::Tags.new
    @tags.contact_url = 'http://www.example.com.pl'
    @tags.license_name = 'CC-BY-SA'
    expected = 'Licensed to the public under CC-BY-SA verify at http://www.example.com.pl'
    assert_equal expected, @tags.copyright_description
  end

  def test_sets_all_tags
    artist = Artist.new(
      name: 'Jęczące Brzękodźwięki',
      reference: 'jeczace-brzekodzwieki'
    )
    album = Album.new(
      artist: artist,
      year: 2020,
      title: 'Tłuczące pokrowce jeżozwierza',
      reference: 'tluczace-pokrowce-jezozwierza'
    )
    track = album.tracks.new(
      title: 'Przebój',
      rank: 1
    )

    tags = Releaser::Tags.build_for(track, publisher: Publisher.instance)
    assert_equal('Jęczące Brzękodźwięki', tags.artist)
    assert_equal('Tłuczące pokrowce jeżozwierza', tags.album)
    assert_equal(2020, tags.year)
    assert_equal('Przebój', tags.title)
    assert_equal(1, tags.track)

    assert_equal('http://www.karoryfer.com/jeczace-brzekodzwieki/wydawnictwa/tluczace-pokrowce-jezozwierza', tags.contact_url)
    assert_equal('Karoryfer Lecolds', tags.organization_name)
    assert_equal('http://www.karoryfer.com', tags.organization_url)
  end

  def test_uses_artist_name_from_track_if_set
    artist = Artist.new(
      name: 'Jęczące Brzękodźwięki',
      reference: 'jeczace-brzekodzwieki'
    )
    album = Album.new(
      artist: artist,
      title: 'Tłuczące pokrowce jeżozwierza',
      reference: 'tluczace-pokrowce-jezozwierza'
    )
    track = album.tracks.new(
      title: 'Przebój',
      artist_name: 'Świszczące Fujary',
      rank: 1
    )

    tags = Releaser::Tags.build_for(track, publisher: Publisher.instance)
    assert_equal('Świszczące Fujary', tags.artist)
  end
end
