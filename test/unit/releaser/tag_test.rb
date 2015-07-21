require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @tmp_dir = Dir.mktmpdir
    FileUtils.cp(File.join(FIXTURES_DIR, 'test.flac'), @tmp_dir)
    FileUtils.cp(File.join(FIXTURES_DIR, 'test.ogg'), @tmp_dir)
    FileUtils.cp(File.join(FIXTURES_DIR, 'test.mp3'), @tmp_dir)
    @tag = Releaser::Tag.new
    @tag.artist = 'Jęczące Brzękodźwięki'
    @tag.album = 'Tłuczące pokrowce jeżozwierza'
    @tag.year = (1933..2020).to_a.sample
    @tag.title = Faker::Lorem.words.join(' ')
    @tag.track = (1..20).to_a.sample
    @tag.comment = Faker::Lorem.sentence
    @tag.contact_url = Faker::Internet.url
    @tag.organization_name = Faker::Name.name
    @tag.organization_url = Faker::Internet.url
    @tag.license_name = Faker::Lorem.word
    @tag.copyright = Faker::Lorem.sentence
  end

  def teardown
    FileUtils.remove_entry_secure @tmp_dir
  end

  def test_applies_tags_to_flac_file
    path = File.join(@tmp_dir, 'test.flac')
    @tag.apply_to(path)
    fetch_tags(path) do |found|
      assert_vorbis_tags(@tag, found)
    end
  end

  def test_applies_tags_to_ogg_file
    path = File.join(@tmp_dir, 'test.ogg')
    @tag.apply_to(path)
    fetch_tags(path) do |found|
      assert_vorbis_tags(@tag, found)
    end
  end

  def test_applies_tags_to_mp3_file
    path = File.join(@tmp_dir, 'test.mp3')
    @tag.apply_to(path)
    fetch_tags(path) do |found|
      assert_mp3_tags(@tag, found)
    end
  end

  def fetch_tags(track_path)
    case File.extname(track_path)
    when '.ogg'
      TagLib::Ogg::Vorbis::File.open(track_path) do |file|
        yield file.tag
      end
    when '.mp3'
      TagLib::MPEG::File.open(track_path) do |file|
        yield file.id3v2_tag
      end
    when '.flac'
      TagLib::FLAC::File.open(track_path) do |file|
        yield file.xiph_comment
      end
    else
      fail
    end
  end

  def assert_common_tags(expected, found)
    assert_equal expected.artist, found.artist
    assert_equal expected.album, found.album
    assert_equal expected.year, found.year
    assert_equal expected.title, found.title
    assert_equal expected.track, found.track
    assert_equal expected.comment, found.comment
  end

  def assert_vorbis_tags(expected, found)
    assert_common_tags(expected, found)
    assert_equal [expected.contact_url], found.field_list_map['CONTACT']
    assert_equal [expected.license_name], found.field_list_map['LICENSE']
    assert_equal [expected.organization_name], found.field_list_map['ORGANIZATION']
    assert_equal [expected.copyright], found.field_list_map['COPYRIGHT']
  end

  def assert_mp3_tags(expected, found)
    assert_common_tags(expected, found)
    assert_equal 'Other', found.genre
    assert_nil found.frame_list('WOAR').first

    wpub = found.frame_list('WPUB').first
    assert wpub.kind_of? TagLib::ID3v2::UrlLinkFrame
    assert_equal expected.organization_url, wpub.to_s
    tpub = found.frame_list('TPUB').first
    assert tpub.kind_of? TagLib::ID3v2::TextIdentificationFrame
    assert_equal expected.organization_name, tpub.to_s

    if expected.license_name
      wcop = found.frame_list('WCOP').first
      assert wcop.kind_of? TagLib::ID3v2::UrlLinkFrame
      assert_equal expected.license_name, wcop.to_s
      woaf = found.frame_list('WOAF').first
      assert woaf.kind_of? TagLib::ID3v2::UrlLinkFrame
      assert_equal expected.contact_url, woaf.to_s
      tcop = found.frame_list('TCOP').first
      assert tcop.kind_of? TagLib::ID3v2::TextIdentificationFrame
      assert_equal "#{expected.copyright}. #{expected.copyright_description}", tcop.to_s
      assert found.frame_list('WCOP').empty?
      assert found.frame_list('WOAF').empty?
      assert found.frame_list('TCOP').empty?
    end
  end

  def test_copyright_description
    @tag = Releaser::Tag.new
    @tag.contact_url = 'http://www.example.com.pl'
    @tag.license_name = 'CC-BY-SA'
    assert_equal 'Licensed to the public under CC-BY-SA verify at http://www.example.com.pl',
      @tag.copyright_description
  end
end
