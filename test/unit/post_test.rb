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

	def test_is_published_or_unpublished
		post = Post.sham! :build
		[true, false].each do |v|
			post.published = v
			assert post.valid?
		end
		post.published = nil
		refute post.valid?
		assert post.errors[:published].include? I18n.t(
      'activerecord.errors.models.post.attributes.published.inclusion' )
	end

  def test_published_scope_returns_all_published
    3.times { Post.sham!( published: true ) }
    3.times { Post.sham!( published: false ) }
    assert_equal 3, Post.published.count
    Post.published.each do |post|
      assert post.published?
    end
  end

  def test_unpublished_scope_returns_all_unpublished
    3.times { Post.sham!( published: true ) }
    3.times { Post.sham!( published: false ) }
    assert_equal 3, Post.unpublished.count
    Post.unpublished.each do |post|
      refute post.published?
    end
  end

	def test_is_published_by_default
		refute Post.new.published?
	end

  def test_some_scope_does_not_return_too_many
    15.times { Post.sham! }
    assert Post.some.size <= Post::SOME_LIMIT
  end
end

