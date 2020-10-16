# frozen_string_literal: true

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  describe Album do
    it 'validates title presence' do
      album = Album.sham! :build
      album.title = nil
      assert !album.valid? && album.invalid?(:title)
      assert album.errors[:title].include? I18n.t(
        'activerecord.errors.models.album.attributes.title.blank'
      )
    end

    it 'validates artist presence' do
      album = Album.sham! :build
      album.artist_id = nil
      refute album.valid?
      assert album.errors[:artist_id].include? I18n.t(
        'activerecord.errors.models.album.attributes.artist_id.blank'
      )
    end

    it 'validates reference presence' do
      album = Album.sham! :build
      album.reference = nil
      refute album.valid?
      assert album.errors[:reference].include? I18n.t(
        'activerecord.errors.models.album.attributes.reference.blank'
      )
    end

    it 'rejects reference with invalid format' do
      album = Album.sham! :build
      [
        'invalid reference',
        'invalid () char@cter$',
        '-invalid',
        '_invalid',
        'invalid-',
        'invalid_',
        'InvalidName',
        'valid_name',
        'val-id_na-me',
        'invalid-_invalid'
      ].each do |reference|
        album.reference = reference
        refute album.valid?, reference
        assert album.errors[:reference].include? I18n.t(
          'activerecord.errors.models.album.attributes.reference.invalid'
        )
      end
    end

    it 'accepts reference with valid format' do
      album = Album.sham! :build
      ['validname', 'valid-name', '5nizza'].each do |reference|
        album.reference = reference
        assert album.valid?, reference
      end
    end

    it 'validates reference length' do
      album = Album.sham! :build
      album.reference = 'a' * (Album::REFERENCE_MAX_LENGTH + 1)
      refute album.valid?
      assert album.errors[:reference].include? I18n.t(
        'activerecord.errors.models.album.attributes.reference.too_long'
      )

      album.reference = 'a' * Album::REFERENCE_MAX_LENGTH
      assert album.valid?
    end

    it 'validates reference uniqueness' do
      existing = Album.sham!
      album = Album.sham! :build
      [
        existing.reference,
        existing.reference.upcase,
        existing.reference.capitalize,
        existing.reference.swapcase
      ].each do |u|
        album.reference = u
        refute album.valid?, u
        assert album.errors[:reference].include? I18n.t(
          'activerecord.errors.models.album.attributes.reference.taken'
        )
      end
    end

    it 'validates title length' do
      album = Album.sham! :build
      album.title = 'a' * (Album::TITLE_MAX_LENGTH + 1)
      refute album.valid?
      assert album.errors[:title].include? I18n.t(
        'activerecord.errors.models.album.attributes.title.too_long'
      )
      album.title = 'a' * Album::TITLE_MAX_LENGTH
      assert album.valid?
    end

    it 'validates year length' do
      album = Album.sham! :build
      %w[12345 123].each do |year|
        album.year = year
        refute album.valid?
        assert album.errors[:year].include? I18n.t(
          'activerecord.errors.models.album.attributes.year.wrong_length'
        )
      end

      album.year = '1234'
      assert album.valid?
    end

    it 'validates year numericality' do
      album = Album.sham! :build
      album.year = '1a34'
      refute album.valid?
      assert album.errors[:year].include? I18n.t(
        'activerecord.errors.models.album.attributes.year.not_a_number'
      )
    end

    it 'allows empty license' do
      album = Album.sham! :build
      album.license_id = nil
      assert album.valid?
    end

    it 'is published or unpublished' do
      album = Album.sham! :build
      [true, false].each do |v|
        album.published = v
        assert album.valid?
      end
      album.published = nil
      refute album.valid?
      assert album.errors[:published].include? I18n.t(
        'activerecord.errors.models.album.attributes.published.inclusion'
      )
    end

    describe 'published scope' do
      it 'returns all published' do
        3.times { assert Album.sham!(:published).valid? }
        3.times { assert Album.sham!(:unpublished).valid? }
        assert_equal 6, Album.count
        assert_equal 3, Album.published.count
        Album.published.each do |album|
          assert album.published?
        end
      end
    end

    describe 'unpublished scope' do
      it 'returns all unpublished' do
        3.times { assert Album.sham!(:published).valid? }
        3.times { assert Album.sham!(:unpublished).valid? }
        assert_equal 6, Album.count
        assert_equal 3, Album.unpublished.count
        Album.unpublished.each do |album|
          refute album.published?
        end
      end
    end

    it 'is published by default' do
      refute Album.new.published?
    end

    it 'cannot be removed when has releases' do
      skip 'learn how to sham a release'
      # album = Album.sham!
      # release = album.releases.create(format: 'flac')
      # assert Release.where(id: release.id).exists?
      # refute album.destroy
      # assert Release.where(id: release.id).exists?
    end

    it 'cascade destroys all attachments on destroy' do
      attachment = Attachment.sham!
      album = attachment.album
      assert Attachment.where(id: attachment.id).exists?
      album.destroy
      refute Attachment.where(id: attachment.id).exists?
    end
  end
end
