class License < ActiveRecord::Base
  validates :symbol, :version, :name, presence: true
  has_many :albums

  def url
    "http://creativecommons.org/licenses/#{symbol}/#{version}/deed.pl"
  end

  def icon_url
    "http://i.creativecommons.org/l/#{symbol}/#{version}/88x31.png"
  end

  def full_name
    I18n.t("license.cc-#{symbol}-#{version.parameterize}")
  end
end
