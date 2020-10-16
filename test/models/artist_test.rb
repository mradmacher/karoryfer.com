# frozen_string_literal: true

require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  describe Artist do
    it 'has valid sham' do
      assert Artist.sham!(:build).valid?
    end

    it 'validates name presence' do
      artist = Artist.sham! :build
      artist.name = nil
      refute artist.valid?
      assert artist.errors[:name].include? I18n.t(
        'activerecord.errors.models.artist.attributes.name.blank'
      )
    end

    it 'validates name length' do
      artist = Artist.sham! :build
      artist.name = 'a' * (Artist::NAME_MAX_LENGTH + 1)
      refute artist.valid?
      assert artist.errors[:name].include? I18n.t(
        'activerecord.errors.models.artist.attributes.name.too_long'
      )

      artist.name = 'a' * Artist::NAME_MAX_LENGTH
      assert artist.valid?
    end

    it 'validates reference presence' do
      artist = Artist.sham! :build
      artist.reference = nil
      refute artist.valid?
      assert artist.errors[:reference].include? I18n.t(
        'activerecord.errors.models.artist.attributes.reference.blank'
      )
    end

    it 'rejects invalid reference formats' do
      artist = Artist.sham!(:build)
      [
        'invalid ref name',
        'invalid () char@cter$',
        '-invalid',
        '_invalid',
        'invalid-',
        'invalid_',
        'InvalidName',
        'invalid-_invalid'
      ].each do |reference|
        artist.reference = reference
        refute artist.valid?, reference
        assert artist.errors[:reference].include? I18n.t(
          'activerecord.errors.models.artist.attributes.reference.invalid'
        )
      end
    end

    it 'accepts valid reference formats' do
      artist = Artist.sham! :build
      [
        'validname',
        'valid-name',
        'valid_name',
        '5nizza',
        'val-id_na-me'
      ].each do |reference|
        artist.reference = reference
        assert artist.valid?, reference
      end
    end

    it 'validates reference length' do
      artist = Artist.sham! :build
      artist.reference = 'a' * (Artist::REFERENCE_MAX_LENGTH + 1)
      refute artist.valid?
      assert artist.errors[:reference].include? I18n.t(
        'activerecord.errors.models.artist.attributes.reference.too_long'
      )

      artist.reference = 'a' * Artist::REFERENCE_MAX_LENGTH
      assert artist.valid?
    end

    it 'validates reference exclusion' do
      artist = Artist.sham! :build
      %w[
        artysci
        wydawnictwa
      ].each do |reserved|
        artist.reference = reserved
        refute artist.valid?, reserved
        assert artist.errors[:reference].include? I18n.t(
          'activerecord.errors.models.artist.attributes.reference.exclusion'
        )
      end
    end

    it 'validates reference uniqueness' do
      existing = Artist.sham!
      artist = Artist.sham! :build
      [
        existing.reference,
        existing.reference.upcase,
        existing.reference.capitalize,
        existing.reference.swapcase
      ].each do |ref|
        artist.reference = ref
        refute artist.valid?
        assert artist.errors[:reference].include? I18n.t(
          'activerecord.errors.models.artist.attributes.reference.taken'
        )
      end
    end

    it 'finds by reference' do
      expected = Artist.sham!
      artist = Artist.find_by_reference expected.reference.upcase
      assert_equal expected, artist
    end
  end
end
