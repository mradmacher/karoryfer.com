# frozen_string_literal: true

require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  describe Release do
    it 'validates album presence' do
      release = Release.sham! :build
      release.album = nil
      refute release.valid?
      assert release.errors[:album_id].include? I18n.t(
        'activerecord.errors.models.release.attributes.album_id.blank'
      )

      release.album = Album.sham!
      assert release.valid?
    end

    it 'validates format presence' do
      release = Release.sham! :build
      [nil, ''].each do |format|
        release.format = format
        refute release.valid?
        assert release.errors[:format].include? I18n.t(
          'activerecord.errors.models.release.attributes.format.blank'
        )
      end
    end

    it 'validates format inclusion' do
      release = Release.sham! :build
      %w[oga mp floc].each do |format|
        release.format = format
        refute release.valid?
        assert release.errors[:format].include? I18n.t(
          'activerecord.errors.models.release.attributes.format.inclusion'
        )
      end

      Release::FORMATS.each do |format|
        release.format = format
        assert release.valid?
      end
    end

    it 'validates external url format' do
      release = Release.sham! :build
      release.format = Release::EXTERNAL
      release.external_url = 'not.valid.url'
      refute release.valid?
      assert release.errors[:external_url].include? I18n.t(
        'activerecord.errors.models.release.attributes.external_url.invalid'
      )
      release.external_url = 'http://bumtralala.karoryfer.com/album/krowka'
      assert release.valid?
    end

    it 'requires external url if no file' do
      release = Release.sham!(:build)
      release.remove_file!
      release.external_url = nil
      [Release::MP3, Release::OGG, Release::FLAC, Release::ZIP].each do |format|
        release.format = format
        refute release.valid?
      end
      release.external_url = 'http://www.example.com'
      [Release::MP3, Release::OGG, Release::FLAC, Release::ZIP].each do |format|
        release.format = format
        assert release.valid?
      end
    end

    it 'requires file if no external url' do
      release = Release.sham!(:build)
      release.remove_file!
      release.external_url = nil
      [Release::MP3, Release::OGG, Release::FLAC, Release::ZIP].each do |format|
        release.format = format
        refute release.valid?
      end
      release.file = File.open("#{FIXTURES_DIR}/release.zip")
      [Release::MP3, Release::OGG, Release::FLAC, Release::ZIP].each do |format|
        release.format = format
        assert release.valid?
      end
    end

    it 'does not require price and currency presence when not for sale' do
      release = Release.sham! :build
      release.format = Release::CD
      release.for_sale = false
      release.whole_price = nil
      release.currency = nil
      assert release.valid?
    end

    it 'does not require price and currency presence when for sale but not published' do
      release = Release.sham!(:build, published: false)
      release.format = Release::CD
      release.for_sale = true
      release.whole_price = nil
      release.currency = nil
      assert release.valid?
    end

    it 'requires price and currency presence when for sale and published' do
      release = Release.sham! :build
      release.format = Release::CD
      release.for_sale = true
      release.whole_price = nil
      release.currency = nil
      refute release.valid?

      release.whole_price = 100
      refute release.valid?

      release.whole_price = nil
      release.currency = 'USD'
      refute release.valid?

      release.whole_price = 100
      release.currency = 'USD'
      assert release.valid?
    end

    describe '#price' do
      it 'returns the whole price by 100' do
        release = Release.sham! :build
        release.whole_price = 199
        assert_equal 1.99, release.price
      end
    end

    describe '#price=' do
      it 'sets the whole price times 100' do
        release = Release.sham! :build
        release.price = 1.99
        assert_equal 199, release.whole_price
      end
    end
  end
end
