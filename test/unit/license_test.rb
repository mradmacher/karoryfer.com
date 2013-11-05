require 'test_helper'

class LicenseTest < ActiveSupport::TestCase
  def test_validates_symbol_presence
    license = License.sham! :build
    [nil, '', '  '].each do |s|
      license.symbol = s
      refute license.valid?
      assert license.errors[:symbol].include? I18n.t( 
        'activerecord.errors.models.license.attributes.symbol.blank' )
    end
  end

  def test_validates_version_presence
    license = License.sham! :build
    [nil, '', '  '].each do |v|
      license.version = v
      refute license.valid?
      assert license.errors[:version].include? I18n.t( 
        'activerecord.errors.models.license.attributes.version.blank' )
    end
  end

  def test_validates_name_presence
    license = License.sham! :build
    [nil, '', '  '].each do |n|
      license.name = n
      refute license.valid?
      assert license.errors[:name].include? I18n.t( 
        'activerecord.errors.models.license.attributes.name.blank' )
    end
  end

  def test_validates_url_presence
    license = License.sham! :build
    refute_nil license.url
    refute_nil license.icon_url
  end

  def test_has_full_name_for_standard_licenses
    license = License.sham! :build
    [['by', '3.0'], 
    ['by-sa', '3.0'], 
    ['by-nc-sa', '3.0']].each do |symbol, version|
      license.symbol = symbol
      license.version = version
      refute_nil license.full_name
    end
  end
end

