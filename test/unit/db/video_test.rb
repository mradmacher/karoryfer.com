require 'test_helper'

class VideoDBTest < ActiveSupport::TestCase
  def setup
    DB[:artists].insert(name: Faker::Name.name, reference: Faker::Name.name.parameterize)
    @artist_id = DB[:artists].first[:id]
  end

  def teardown
    DB[:videos].truncate
  end

  def test_complains_about_nil_title
    exception = assert_raises Sequel::NotNullConstraintViolation do
      DB[:videos].insert(artist_id: @artist_id, url: '')
    end
    assert_match(/title/, exception.message)
  end

  def test_complains_about_blank_title
    exception = assert_raises Sequel::CheckConstraintViolation do
      ['', ' ', '   '].each do |title|
        DB[:videos].insert(title: title, artist_id: @artist_id, url: '')
      end
      assert_match(/videos_title_check_blank/, exception.message)
    end
  end

  def test_complains_about_too_long_title
    exception = assert_raises Sequel::DatabaseError do
      DB[:videos].insert(title: 'a' * 81, artist_id: @artist_id, url: '')
    end
    assert_match(/\(80\)/, exception.message)

    assert_nothing_raised do
      DB[:videos].insert(title: 'a' * 80, artist_id: @artist_id, url: '')
    end
  end

  def test_complains_about_nil_artist
    exception = assert_raises Sequel::NotNullConstraintViolation do
      DB[:videos].insert(title: 'some title', url: '')
    end
    assert_match(/artist_id/, exception.message)
  end

  def test_complains_about_not_existing_artist
    exception = assert_raises Sequel::ForeignKeyConstraintViolation do
      DB[:videos].insert(title: 'some title', artist_id: 0, url: '')
    end
    assert_match(/videos_artist_id_fkey/, exception.message)
  end

  def test_complains_about_nil_url
    exception = assert_raises Sequel::NotNullConstraintViolation do
      DB[:videos].insert(title: 'some title', artist_id: @artist_id)
    end
    assert_match(/url/, exception.message)
  end
end
