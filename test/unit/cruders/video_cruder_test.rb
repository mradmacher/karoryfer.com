require 'test_helper'

# Tests for video cruder.
class VideoCruderTest < ActiveSupport::TestCase
  def test_permits_all_allowed_params
    permitted_params = {
      title: 1,
      url: 1,
      body: 1
    }
    rejected_params = {
      dummy: 1
    }
    params = { video: permitted_params.merge(rejected_params) }

    cruder = VideoCruder.new(Ability.new(nil), params, nil)
    permitted_params.keys.each do |p|
      assert cruder.permitted_params.include?(p)
    end
    rejected_params.keys.each do |p|
      refute cruder.permitted_params.include?(p)
    end
  end
end
