# encoding: utf-8
require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def test_validates_title_presence
    event = Event.sham! :build
    event.title = nil
    refute event.valid?
    assert event.errors[:title].include? I18n.t(
      'activerecord.errors.models.event.attributes.title.blank')

    event.title = '  '
    refute event.valid?
    assert event.errors[:title].include? I18n.t(
      'activerecord.errors.models.event.attributes.title.blank')
  end

  def test_validates_title_length
    event = Event.sham! :build
    event.title = 'a' * (Event::TITLE_MAX_LENGTH + 1)
    refute event.valid?
    assert event.errors[:title].include? I18n.t(
      'activerecord.errors.models.event.attributes.title.too_long')

    event.title = 'a' * Event::TITLE_MAX_LENGTH
    assert event.valid?
  end

  def test_validates_artist_presence
    event = Event.sham! :build
    event.artist_id = nil
    refute event.valid?
    assert event.errors[:artist_id].include? I18n.t(
      'activerecord.errors.models.event.attributes.artist_id.blank')
  end

  def test_has_not_free_entrance_by_default
    refute Event.new.free_entrance?
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
      'activerecord.errors.models.event.attributes.free_entrance.inclusion')
  end

  def test_validates_date_presence
    event = Event.sham! :build
    event.event_date = nil
    refute event.valid?
    assert event.errors[:event_date].include? I18n.t(
      'activerecord.errors.models.event.attributes.event_date.blank')

    event.event_date = Time.now.utc.to_date
    assert event.valid?
  end

  def test_returns_not_too_many_for_some_scope
    15.times { Event.sham!(:event) }
    assert Event.some.size <= Event::SOME_LIMIT
  end

  def test_expired_behaves_properly
    event = Event.new

    event.event_date = nil
    refute event.expired?

    event.event_date = Time.zone.today
    refute event.expired?

    event.event_date = event.event_date + 1.day
    refute event.expired?

    event.event_date = Date.yesterday
    assert event.expired?

    event.duration = 1
    refute event.expired?
  end

  def test_recognized_external_urls_recognize_http_and_https_urls
    event = Event.new
    event.external_urls = <<-URLS
      https://www.facebook.com/event/12345
      ftp://example.com
      http://www.twitter.com/154321 http://karoryfer.pl/Hanba1926
      mailto:john@example.com
    URLS

    refute event.recognized_external_urls.key?('ftp://example.com')
    refute event.recognized_external_urls.key?('mailto:john@example.com')

    assert event.recognized_external_urls.key?('https://www.facebook.com/event/12345')
    assert_equal 'www.facebook.com', event.recognized_external_urls['https://www.facebook.com/event/12345']

    assert event.recognized_external_urls.key?('http://www.twitter.com/154321')
    assert_equal 'www.twitter.com', event.recognized_external_urls['http://www.twitter.com/154321']

    assert event.recognized_external_urls.key?('http://karoryfer.pl/Hanba1926')
    assert_equal 'karoryfer.pl', event.recognized_external_urls['http://karoryfer.pl/Hanba1926']
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
end
