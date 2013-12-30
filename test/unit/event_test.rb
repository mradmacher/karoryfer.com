# encoding: utf-8
require 'test_helper'

class EventTest < ActiveSupport::TestCase
	def test_validates_title_presence
		event = Event.sham! :build
		event.title = nil
		refute event.valid?
		assert event.errors[:title].include? I18n.t(
      'activerecord.errors.models.event.attributes.title.blank' )

		event.title = '  '
		refute event.valid?
		assert event.errors[:title].include? I18n.t(
      'activerecord.errors.models.event.attributes.title.blank' )
	end

	def test_validates_title_length
		event = Event.sham! :build
		event.title = 'a'*(Event::TITLE_MAX_LENGTH+1)
		refute event.valid?
		assert event.errors[:title].include? I18n.t(
      'activerecord.errors.models.event.attributes.title.too_long' )

		event.title = 'a'*(Event::TITLE_MAX_LENGTH)
		assert event.valid?
	end

	def test_validates_artist_presence
		event = Event.sham! :build
		event.artist_id = nil
		refute event.valid?
		assert event.errors[ :artist_id ].include? I18n.t(
      'activerecord.errors.models.event.attributes.artist_id.blank' )
	end

  def test_has_not_free_entrance_by_default
    refute Event.new.free_entrance?
  end

	def test_is_published_or_unpublished
		event = Event.sham! :build
		[true, false].each do |v|
			event.published = v
			assert event.valid?
		end
		event.published = nil
		refute event.valid?
		assert event.errors[:published].include? I18n.t(
      'activerecord.errors.models.event.attributes.published.inclusion' )
	end

  def test_has_free_enctrance_or_not
		event = Event.sham! :build
		[true, false].each do |v|
			event.free_entrance = v
			assert event.valid?
		end
		event.free_entrance = nil
		refute event.valid?
		assert event.errors[:free_entrance].include? I18n.t(
      'activerecord.errors.models.event.attributes.free_entrance.inclusion' )
	end

  def test_validates_date_presence
    event = Event.sham! :build
    event.event_date = nil
    refute event.valid?
    assert event.errors[:event_date].include? I18n.t(
      'activerecord.errors.models.event.attributes.event_date.blank' )

    event.event_date = Time.now.to_date
    assert event.valid?
  end

  def test_returns_all_published_for_published_scope
    3.times { Event.sham!( published: true ) }
    3.times { Event.sham!( published: false ) }
    assert_equal 3, Event.published.count
    Event.published.each do |event|
      assert event.published?
    end
  end

  def test_returns_all_unpublished_for_unpublished_scope
    3.times { Event.sham!( published: true ) }
    3.times { Event.sham!( published: false ) }
    assert_equal 3, Event.unpublished.count
    Event.unpublished.each do |event|
      refute event.published?
    end
  end

  def test_is_unpublished_by_default
		refute Event.new.published?
	end

  def test_returns_not_too_many_for_some_scope
    15.times { Event.sham!( :event ) }
    assert Event.some.size <= Event::SOME_LIMIT
  end

  def test_expired_behaves_properly
    event = Event.new

    event.event_date = nil
    refute event.expired?

    event.event_date = Date.today
    refute event.expired?

    event.event_date = event.event_date + 1.day
    refute event.expired?

    event.event_date = Date.yesterday
    assert event.expired?

    event.duration = 1
    refute event.expired?
  end

  def test_recognized_external_urls_recognize_facebook
    event = Event.new
    event.external_urls= <<-URLS
      http://www.facebook.com/event/12345
      http://www.twitter.com/154321 http://www.facebook.com/Hanba1234
    URLS

    assert event.recognized_external_urls.has_key?( 'http://www.facebook.com/event/12345' )
    assert_equal :facebook, event.recognized_external_urls['http://www.facebook.com/event/12345']

    assert event.recognized_external_urls.has_key?( 'http://www.facebook.com/Hanba1234' )
    assert_equal :facebook, event.recognized_external_urls['http://www.facebook.com/Hanba1234']
  end

  def test_recognized_external_urls_does_not_crash_when_external_urls_are_nil
    event = Event.new
    event.external_urls = nil
    assert event.recognized_external_urls == {}
  end

  def test_recognized_external_urls_does_not_crash_when_external_urls_are_blank
    event = Event.new
    event.external_urls = ''
    assert event.recognized_external_urls == {}
  end

  def test_for_day_scope_returns_all_for_given_day
    event2010_04_10 = [Event.sham!( event_date: Date.new( 2010, 4, 10 ) ),
      Event.sham!( event_date: Date.new( 2010, 4, 10 ) )]
    Event.sham!( event_date: Date.new( 2010, 4, 9 ) )
    Event.sham!( event_date: Date.new( 2010, 4, 11 ) )
    Event.sham!( event_date: Date.new( 2010, 3, 10 ) )
    Event.sham!( event_date: Date.new( 2011, 4, 10 ) )

    result = Event.for_day( 2010, 4, 10 )
    assert_equal 2, result.size
    assert result.include?( event2010_04_10[0] )
    assert result.include?( event2010_04_10[1] )
  end

  def test_for_day_scope_returns_nothing_when_there_is_nothing_for_given_day
    Event.sham!( event_date: Date.new( 2009, 3, 2 ) )
    Event.sham!( event_date: Date.new( 2010, 4, 9 ) )
    Event.sham!( event_date: Date.new( 2011, 3, 2 ) )
    assert Event.for_day( 2010, 3, 2 ).empty?
  end

  def test_for_month_scope_returns_all_for_given_month
    event2010_04 = [Event.sham!( event_date: Date.new( 2010, 4, 10 ) ),
      Event.sham!( event_date: Date.new( 2010, 4, 10 ) ),
      Event.sham!( event_date: Date.new( 2010, 4, 7 ) ),
      Event.sham!( event_date: Date.new( 2010, 4, 28 ) )]
    Event.sham!( event_date: Date.new( 2010, 3, 11 ) )
    Event.sham!( event_date: Date.new( 2011, 4, 10 ) )

    result = Event.for_month( 2010, 4 )
    assert_equal 4, result.size
    assert result.include?( event2010_04[0] )
    assert result.include?( event2010_04[1] )
    assert result.include?( event2010_04[2] )
    assert result.include?( event2010_04[3] )
  end

  def test_for_month_scope_returns_nothing_when_there_is_nothing_for_given_month
    Event.sham!( event_date: Date.new( 2009, 5, 11 ) )
    Event.sham!( event_date: Date.new( 2010, 3, 11 ) )
    Event.sham!( event_date: Date.new( 2011, 5, 11 ) )
    assert Event.for_month( 2010, 5 ).empty?
  end

  def test_for_year_scope_returns_all_for_given_year
    event2010 = [Event.sham!( event_date: Date.new( 2010, 4, 10 ) ),
      Event.sham!( event_date: Date.new( 2010, 2, 10 ) ),
      Event.sham!( :event, event_date: Date.new( 2010, 12, 28 ) )]
    Event.sham!( event_date: Date.new( 2011, 4, 10 ) )
    Event.sham!( event_date: Date.new( 2011, 4, 10 ) )
    result = Event.for_year( 2010 )
    assert_equal 3, result.size
    assert result.include?( event2010[0] )
    assert result.include?( event2010[1] )
    assert result.include?( event2010[2] )
  end

  def test_for_year_scope_returns_nothing_when_there_is_nothing_for_given_year
    Event.sham!( event_date: Date.new( 2011, 4, 10 ) )
    assert Event.for_year( 2015 ).empty?
  end
end

