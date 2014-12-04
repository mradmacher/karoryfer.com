require 'test_helper'

# Tests for page resource.
class PagePostResourceTest < ActiveSupport::TestCase
  def test_resource_class_is_video
    resource = Resource::PageResource.new(Ability.new(nil), {})
    assert_equal Page, resource.resource_class
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

    resource = Resource::PageResource.new(Ability.new(nil), params)
    permitted_params.keys.each do |p|
      assert resource.permitted_params.include?(p)
    end
    rejected_params.keys.each do |p|
      refute resource.permitted_params.include?(p)
    end
  end
end


