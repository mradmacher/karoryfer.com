require 'test_helper'

class LicenseTest < ActiveSupport::TestCase
  def test_url
    license = License::CC_BY_SA_40
    assert_equal 'http://creativecommons.org/licenses/by-sa/4.0/deed.pl', license.url
  end

  def test_icon_url
    license = License::CC_BY_SA_40
    assert_equal 'http://i.creativecommons.org/l/by-sa/4.0/88x31.png', license.icon_url
  end

  def test_has_name_for_standard_licenses
    license = License::CC_BY_SA_40
    assert_equal I18n.t('license.cc-by-sa-4-0'), license.name
  end
end
