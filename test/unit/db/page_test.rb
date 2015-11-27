require 'test_helper'

class PageDBTest < ActiveSupport::TestCase
  def setup
    @artist_id = DB[:artists].insert(name: Faker::Name.name, reference: Faker::Name.name.parameterize)
  end

  def teardown
    DB[:pages].truncate
  end

  def test_complains_about_nil_reference
    exception = assert_raises Sequel::NotNullConstraintViolation do
      DB[:pages].insert(title: 'Title', content: 'Content', artist_id: @artist_id)
    end
    assert_match(/reference/, exception.message)
  end

  def test_complains_about_blank_reference
    exception = assert_raises Sequel::CheckConstraintViolation do
      ['', ' ', '   '].each do |reference|
        DB[:pages].insert(title: 'Title', reference: reference, content: 'Content', artist_id: @artist_id)
      end
      assert_match(/pages_reference_check_blank/, exception.message)
    end
  end

  def test_complains_about_too_long_reference
    exception = assert_raises Sequel::DatabaseError do
      DB[:pages].insert(title: 'Title', reference: 'a' * 81, content: 'Content', artist_id: @artist_id)
    end
    assert_match(/\(80\)/, exception.message)

    assert_nothing_raised do
      DB[:pages].insert(title: 'Title', reference: 'a' * 80, content: 'Content', artist_id: @artist_id)
    end
  end

  def test_complains_about_invalid_reference
    [
      'invalid ref name',
      'invalid()char@cter$',
      'invalid.name',
      'invalid-na_me',
      'invalid.na-me',
      'Invalid',
      'invalid_name'
    ].each do |reference|
      exception = assert_raises Sequel::CheckConstraintViolation, reference do
        DB[:pages].insert(title: 'Title', reference: reference, content: 'Content', artist_id: @artist_id)
      end
      assert_match(/pages_reference_check_format/, exception.message)
    end
  end

  def test_accepts_valid_reference
    ['validname', 'valid-name', '5nizza-group', 'valid-na-me'].each do |reference|
      assert_nothing_raised do
        DB[:pages].insert(title: 'Title', reference: reference, content: 'Content', artist_id: @artist_id)
      end
    end
  end

  def test_complains_about_duplicated_reference
    DB[:pages].insert(title: 'Title', reference: 'reference', content: 'Content', artist_id: @artist_id)
    exception = assert_raises Sequel::UniqueConstraintViolation do
      DB[:pages].insert(title: 'Title2', reference: 'reference', content: 'Content2', artist_id: @artist_id)
    end
    assert_match(/pages_artist_reference_key/, exception.message)
  end

  def test_does_not_complains_about_duplicated_reference_for_different_artists
    other_artist_id = DB[:artists].insert(name: Faker::Name.name, reference: Faker::Name.name.parameterize)
    DB[:pages].insert(title: 'Title', reference: 'reference', content: 'Content', artist_id: @artist_id)
    assert_nothing_raised do
      DB[:pages].insert(title: 'Title2', reference: 'reference', content: 'Content2', artist_id: other_artist_id)
    end
  end

  def test_complains_about_nil_title
    exception = assert_raises Sequel::NotNullConstraintViolation do
      DB[:pages].insert(reference: 'reference', content: 'Content')
    end
    assert_match(/title/, exception.message)
  end

  def test_complains_about_blank_title
    ['', ' ', '   '].each_with_index do |title, index|
      exception = assert_raises Sequel::CheckConstraintViolation do
        DB[:pages].insert(title: title, reference: "reference#{index}", content: 'Content', artist_id: @artist_id)
      end
      assert_match(/pages_title_check_blank/, exception.message)
    end
  end

  def test_complains_about_too_long_title
    exception = assert_raises Sequel::DatabaseError do
      DB[:pages].insert(title: 'a' * 81, reference: 'reference', content: 'Content', artist_id: @artist_id)
    end
    assert_match(/\(80\)/, exception.message)

    assert_nothing_raised do
      DB[:pages].insert(title: 'a' * 80, reference: 'reference', content: 'Content', artist_id: @artist_id)
    end
  end

  def test_complains_about_nil_artist
    exception = assert_raises Sequel::NotNullConstraintViolation do
      DB[:pages].insert(title: 'some title', reference: 'reference')
    end
    assert_match(/artist_id/, exception.message)
  end

  def test_complains_about_not_existing_artist
    exception = assert_raises Sequel::ForeignKeyConstraintViolation do
      DB[:pages].insert(title: 'some title', reference: 'reference', artist_id: 0)
    end
    assert_match(/pages_artist_id_fkey/, exception.message)
  end
end
