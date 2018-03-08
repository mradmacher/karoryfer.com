# frozen_string_literal: true

class License
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def self.find(symbol)
    all.find { |l| l.symbol == symbol }
  end

  CC_BY_30 = License.new('cc by 3.0')
  CC_BY_SA_30 = License.new('cc by-sa 3.0')
  CC_BY_NC_SA_30 = License.new('cc by-nc-sa 3.0')
  CC_BY_40 = License.new('cc by 4.0')
  CC_BY_SA_40 = License.new('cc by-sa 4.0')
  CC_BY_NC_SA_40 = License.new('cc by-nc-sa 4.0')

  def self.all
    [
      CC_BY_30,
      CC_BY_SA_30,
      CC_BY_NC_SA_30,
      CC_BY_40,
      CC_BY_SA_40,
      CC_BY_NC_SA_40
    ]
  end

  def url
    "http://creativecommons.org/licenses/#{shortcut}/#{version}/#{I18n.locale == :en ? '' : "deed.#{I18n.locale}"}"
  end

  def icon_url
    "http://i.creativecommons.org/l/#{shortcut}/#{version}/88x31.png"
  end

  def name
    I18n.t("license.#{symbol.parameterize}")
  end

  def type
    I18n.t('license.cc')
  end

  private

  def shortcut
    @shortcut ||= symbol.split(' ')[1...-1].join('-')
  end

  def version
    @version ||= symbol.split(' ').last
  end
end
