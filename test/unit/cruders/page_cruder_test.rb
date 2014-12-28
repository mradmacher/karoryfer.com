require 'test_helper'

# Tests for page cruder.
class PageCruderTest < ActiveSupport::TestCase
  def test_resource_class_is_video
    cruder = PageCruder.new(Ability.new(nil), {})
    assert_equal Page, cruder.resource_class
  end

  def test_permits_all_allowed_params
    permitted_params = {
      title: 1,
      reference: 1,
      content: 1
    }
    rejected_params = {
      dummy: 1
    }
    params = { page: permitted_params.merge(rejected_params) }

    cruder = PageCruder.new(Ability.new(nil), params)
    permitted_params.keys.each do |p|
      assert cruder.permitted_params.include?(p)
    end
    rejected_params.keys.each do |p|
      refute cruder.permitted_params.include?(p)
    end
  end
end