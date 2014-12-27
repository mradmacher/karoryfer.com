require 'test_helper'

# Tests for video cruder.
class VideoCruderTest < ActiveSupport::TestCase
  def test_resource_class_is_video
    cruder = VideoCruder.new(Ability.new(nil), {})
    assert_equal Video, cruder.resource_class
  end

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

    cruder = VideoCruder.new(Ability.new(nil), params)
    permitted_params.keys.each do |p|
      assert cruder.permitted_params.include?(p)
    end
    rejected_params.keys.each do |p|
      refute cruder.permitted_params.include?(p)
    end
  end
end
