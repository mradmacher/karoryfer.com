require 'test_helper'

# Tests for post cruder.
class PostCruderTest < ActiveSupport::TestCase
  def test_permits_all_allowed_params
    permitted_params = {
      title: 1,
      body: 1
    }
    rejected_params = {
      dummy: 1
    }
    params = { post: permitted_params.merge(rejected_params) }

    cruder = PostCruder.new(Ability.new(nil), params, nil)
    permitted_params.keys.each do |p|
      assert cruder.permitted_params.include?(p)
    end
    rejected_params.keys.each do |p|
      refute cruder.permitted_params.include?(p)
    end
  end
end
