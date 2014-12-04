require 'test_helper'

class TestResource
  attr_accessor :id, :permitted, :restricted
  @@storage = {}

  def initialize(attrs = {})
    @permitted = attrs[:permitted]
    @restricted = attrs[:restricted]
  end

  def save
    if valid?
      self.id = Random.new.rand(100)
      @@storage[id] = self
      true
    else
      false
    end
  end

  def valid?(value = self.permitted)
    value != 'invalid'
  end

  def update_attributes(attrs)
    if valid?(attrs[:permitted])
      @permitted = attrs[:permitted] if attrs.has_key?(:permitted)
      @restricted = attrs[:restricted] if attrs.has_key?(:restricted)
      true
    else
      false
    end
  end

  def persisted?
    !id.nil?
  end

  def self.find(id)
    @@storage[id]
  end

  def self.all
    TestResource
  end

  def ==(other)
    self.id == other.id
  end
end

class TestResourceAccess < Resource::RegularResource
  def resource_class
    TestResource
  end

  def permitted_params
    strong_parameters.require(:test_resource).permit(:permitted)
  end
end

# Tests for resource resource.
class RegularResourceTest < ActiveSupport::TestCase
  def test_index_is_authorized
    assert_authorization :read, TestResource do |abilities|
      resource_access({}, abilities).index
    end
  end

  def test_show_is_authorized
    (resource = TestResource.new).save
    assert_authorization :read, resource do |abilities|
      resource_access({ id: resource.id }, abilities).show
    end
  end

  def test_show_returns_resource_with_provided_id
    (resource = TestResource.new).save
    with_permission_to :read, resource do |abilities|
      result = resource_access({ id: resource.id }, abilities).show
      assert_equal resource, result
    end
  end

  def test_new_is_authorized
    assert_authorization :write, TestResource do |abilities|
      resource_access({}, abilities).new
    end
  end

  def test_new_returns_new_resource
    with_permission_to :write, TestResource do |abilities|
      result = resource_access({}, abilities).new
      assert result.is_a? TestResource
      refute result.persisted?
    end
  end

  def test_edit_is_authorized
    (resource = TestResource.new).save
    assert_authorization :write, resource do |abilities|
      resource_access({ id: resource.id }, abilities).edit
    end
  end

  def test_edit_returns_resource_with_provided_id
    (resource = TestResource.new).save
    with_permission_to :write, resource do |abilities|
      result = resource_access({ id: resource.id }, abilities).edit
      assert_equal resource, result
    end
  end

  def test_create_is_authorized
    attributes = { dummy: 1 }
    assert_authorization :write, TestResource do |abilities|
      resource_access({ test_resource: attributes }, abilities).create
    end
  end

  def test_create_creates_resource
    attributes = { dummy: 1 }
    result = nil
    with_permission_to :write, TestResource do |abilities|
      result = resource_access({ test_resource: attributes }, abilities).create
    end
    refute result.nil?
    assert result.persisted?
  end

  def test_create_assignes_only_permitted_params
    attributes = { permitted: 'permitted', restricted: 'restricted' }
    result = nil
    with_permission_to :write, TestResource do |abilities|
      result = resource_access({ test_resource: attributes }, abilities).create
    end
    assert_equal 'permitted', result.permitted
    assert_nil result.restricted
  end

  def test_create_raises_exception_for_invalid_attributes
    with_permission_to :write, TestResource do |abilities|
      assert_raises Resource::InvalidResource do
        resource_access({ test_resource: { permitted: 'invalid' } }, abilities).create
      end
    end
  end

  def test_update_is_authorized
    (resource = TestResource.new).save
    assert_authorization :write, resource do |abilities|
      resource_access({ id: resource.id, test_resource: { dummy: 1 } }, abilities).update
    end
  end

  def test_update_updates_resource
    (resource = TestResource.new(permitted: 'old')).save
    result = nil
    result = with_permission_to :write, resource do |abilities|
      params = { id: resource.id, test_resource: { permitted: 'new' } }
      resource_access(params, abilities).update
    end
    assert_equal 'new', result.permitted
    assert_equal resource, result
  end

  def test_update_updates_only_permitted_params
    (resource = TestResource.new(permitted: 'old', restricted: 'old')).save
    result = nil
    result = with_permission_to :write, resource do |abilities|
      params = { id: resource.id, test_resource: { permitted: 'new', restricted: 'new' } }
      resource_access(params, abilities).update
    end
    assert_equal 'new', result.permitted
    assert_equal 'old', result.restricted
    assert_equal resource, result
  end

  def test_update_raises_exception_for_invalid_attributes
    (resource = TestResource.new).save
    with_permission_to :write, resource do |abilities|
      assert_raises Resource::InvalidResource do
        params = { id: resource.id, test_resource: { permitted: 'invalid' } }
        resource_access(params, abilities).update
      end
    end
  end

  def resource_access(params, abilities)
    TestResourceAccess.new(abilities, params)
  end
end
