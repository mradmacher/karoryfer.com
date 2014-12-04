require 'test_helper'

# Tests for event resource.
class EventResourceTest < ActiveSupport::TestCase
  def test_resource_class_is_event
    resource = Resource::EventResource.new(Ability.new(nil), {})
    assert_equal Event, resource.resource_class
  end

  def test_permits_all_allowed_params
    permitted_params = {
      title: 1,
      location: 1,
      address: 1,
      event_date: 1,
      event_time: 1,
      duration: 1,
      free_entrance: 1,
      price: 1,
      poster: 1,
      remove_poster: 1,
      body: 1,
      external_urls: 1
    }
    rejected_params = {
      dummy: 1
    }
    params = { event: permitted_params.merge(rejected_params) }

    resource = Resource::EventResource.new(Ability.new(nil), params)
    permitted_params.keys.each do |p|
      assert resource.permitted_params.include?(p)
    end
    rejected_params.keys.each do |p|
      refute resource.permitted_params.include?(p)
    end
  end
end
