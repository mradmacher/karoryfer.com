# encoding: utf-8
require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def test_validates_title_presence
    post = Post.sham! :build
    post.title = nil
    refute post.valid?
    assert post.errors[:title].include? I18n.t(
      'activerecord.errors.models.post.attributes.title.blank' )

    post.title = '  '
    refute post.valid?
    assert post.errors[:title].include? I18n.t(
      'activerecord.errors.models.post.attributes.title.blank' )
  end

  def test_validates_title_length
    post = Post.sham! :build
    post.title = 'a'*(Post::TITLE_MAX_LENGTH+1)
    refute post.valid?
    assert post.errors[:title].include? I18n.t(
      'activerecord.errors.models.post.attributes.title.too_long' )

    post.title = 'a'*(Post::TITLE_MAX_LENGTH)
    assert post.valid?
  end

  def test_validates_artist_presence
    post = Post.sham! :build
    post.artist_id = nil
    refute post.valid?
    assert post.errors[:artist_id].include? I18n.t(
      'activerecord.errors.models.post.attributes.artist_id.blank' )
  end

  def test_some_scope_does_not_return_too_many
    15.times { Post.sham! }
    assert Post.some.size <= Post::SOME_LIMIT
  end
end

