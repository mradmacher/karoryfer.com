# encoding: utf-8
require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  def test_has_valid_sham
    assert Artist.sham!(:build).valid?
  end

  def test_validates_name_presence
    artist = Artist.sham! :build
    artist.name = nil
    refute artist.valid?
    assert artist.errors[:name].include? I18n.t(
      'activerecord.errors.models.artist.attributes.name.blank')
  end

  def test_validates_name_length
    artist = Artist.sham! :build
    artist.name = 'a' * (Artist::NAME_MAX_LENGTH + 1)
    refute artist.valid?
    assert artist.errors[:name].include? I18n.t(
      'activerecord.errors.models.artist.attributes.name.too_long')

    artist.name = 'a' * (Artist::NAME_MAX_LENGTH)
    assert artist.valid?
  end

  def test_validates_reference_presence
    artist = Artist.sham! :build
    artist.reference = nil
    refute artist.valid?
    assert artist.errors[:reference].include? I18n.t(
      'activerecord.errors.models.artist.attributes.reference.blank')
  end

  def test_rejects_invalid_reference_formats
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
        'activerecord.errors.models.artist.attributes.reference.invalid')
    end
  end

  def test_accepts_valid_reference_formats
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

  def test_validates_reference_length
    artist = Artist.sham! :build
    artist.reference = 'a' * (Artist::REFERENCE_MAX_LENGTH + 1)
    refute artist.valid?
    assert artist.errors[:reference].include? I18n.t(
      'activerecord.errors.models.artist.attributes.reference.too_long')

    artist.reference = 'a' * Artist::REFERENCE_MAX_LENGTH
    assert artist.valid?
  end

  def test_validates_reference_exclusion
    artist = Artist.sham! :build
    %w(
      aktualnosci
      wydarzenia
      wiadomosci
      filmy
      informacje
      artysci
      wydawnictwa
    ).each do |reserved|
      artist.reference = reserved
      refute artist.valid?, reserved
      assert artist.errors[:reference].include? I18n.t(
        'activerecord.errors.models.artist.attributes.reference.exclusion')
    end
  end

  def test_validates_reference_uniqueness
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
        'activerecord.errors.models.artist.attributes.reference.taken')
    end
  end

  def test_finds_by_reference
    expected = Artist.sham!
    artist = Artist.find_by_reference expected.reference.upcase
    assert_equal expected, artist
  end
end
