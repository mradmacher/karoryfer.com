require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  def test_validates_title_presence
    video = Video.sham! :build
    [nil, '', ' '].each do |title|
      video.title = title
      refute video.valid?
      assert video.errors[:title].include? I18n.t(
        'activerecord.errors.models.video.attributes.title.blank')
    end
  end

  def test_validates_url_presence
    video = Video.sham! :build
    [nil, '', ' '].each do |url|
      video.url = url
      refute video.valid?
      assert video.errors[:url].include? I18n.t(
        'activerecord.errors.models.video.attributes.url.blank')
    end
  end

  def test_validates_title_length
    video = Video.sham! :build
    video.title = 'a' * (Video::TITLE_MAX_LENGTH + 1)
    refute video.valid?
    assert video.errors[:title].include? I18n.t(
      'activerecord.errors.models.video.attributes.title.too_long')

    video.title = 'a' * (Video::TITLE_MAX_LENGTH)
    assert video.valid?
  end

  def test_validates_artist_presence
    video = Video.sham! :build
    video.artist_id = nil
    refute video.valid?
    assert video.errors[:artist_id].include? I18n.t(
      'activerecord.errors.models.video.attributes.artist_id.blank')
  end

  def test_some_scope_does_not_return_too_many
    10.times { Video.sham! }
    assert Video.some.size <= Video::SOME_LIMIT
  end
end
