# frozen_string_literal: true

class DownloadEvent < ApplicationRecord
  belongs_to :release
  belongs_to :purchase
end
