require 'test_helper'

class EventDBTest < ActiveSupport::TestCase
  def setup
    @artist_id = DB[:artists].insert( name: Faker::Name.name, reference: Faker::Name.name.parameterize )
  end

  def teardown
    DB[:events].truncate
  end

  def test_complains_about_too_long_address
    exception = assert_raises Sequel::DatabaseError do
      DB[:events].insert( title: 'Title', artist_id: @artist_id, event_date: Date.today, address: 'a'*256 )
    end
    assert_match( /\(255\)/, exception.message )

    assert_nothing_raised do
      DB[:events].insert( title: 'Title', artist_id: @artist_id, event_date: Date.today, address: 'a'*255 )
    end
  end

  def test_complains_about_too_long_time
    exception = assert_raises Sequel::DatabaseError do
      DB[:events].insert( title: 'Title', artist_id: @artist_id, event_date: Date.today, event_time: 'a'*256 )
    end
    assert_match( /\(255\)/, exception.message )

    assert_nothing_raised do
      DB[:events].insert( title: 'Title', artist_id: @artist_id, event_date: Date.today, event_time: 'a'*255 )
    end
  end
end

