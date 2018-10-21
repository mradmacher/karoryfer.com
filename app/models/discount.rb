# frozen_string_literal: true

class Discount < ActiveRecord::Base
  include Priceable

  after_initialize :generate_reference_id

  validates :whole_price, presence: true
  validates :currency, presence: true
  belongs_to :release

  private

  def generate_reference_id
    self.reference_id = SecureRandom.hex if reference_id.nil?
  end
end
