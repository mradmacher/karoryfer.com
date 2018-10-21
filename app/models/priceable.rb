# frozen_string_literal: true

module Priceable
  def price=(value)
    self.whole_price = value.nil? ? nil : (value.to_f*100.0).round(0)
  end

  def price
    return nil if whole_price.nil?
    (whole_price/100.0).round(2)
  end
end
