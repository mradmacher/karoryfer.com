# frozen_string_literal: true

require 'test_helper'

class TestCruder
  include Crudable
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def save(_)
    true
  end

  def delete(_)
    true
  end

  def list; end

  def find; end

  def build; end

  def assign(_); end
end

class AccessOnlyTest < BasePolicy
  def write_access?
    true
  end

  def read_access?
    true
  end
end

class ResourceOnlyTest < BasePolicy
  def write_access_to?(_)
    true
  end

  def read_access_to?(_)
    true
  end
end

class AllPolicyTest < BasePolicy
  def write_access_to?(_)
    true
  end

  def read_access_to?(_)
    true
  end

  def write_access?
    true
  end

  def read_access?
    true
  end
end

class NonePolicyTest < BasePolicy
end

class CruderTest < ActiveSupport::TestCase
  def test_index_is_authorized_for_access_only
    assert_raises(User::AccessDenied) do
      TestCruder.new(NonePolicyTest.new(nil)).index
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(ResourceOnlyTest.new(nil)).index
    end
    assert_nil TestCruder.new(AccessOnlyTest.new(nil)).index
  end

  def test_show_is_authorized
    assert_raises(User::AccessDenied) do
      TestCruder.new(NonePolicyTest.new(nil)).show
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(ResourceOnlyTest.new(nil)).show
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(AccessOnlyTest.new(nil)).show
    end
    assert_nil TestCruder.new(AllPolicyTest.new(nil)).show
  end

  def test_new_is_authorized
    assert_raises(User::AccessDenied) do
      TestCruder.new(NonePolicyTest.new(nil)).new
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(ResourceOnlyTest.new(nil)).new
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(AccessOnlyTest.new(nil)).new
    end
    assert_nil TestCruder.new(AllPolicyTest.new(nil)).new
  end

  def test_edit_is_authorized
    assert_raises(User::AccessDenied) do
      TestCruder.new(NonePolicyTest.new(nil)).edit
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(AccessOnlyTest.new(nil)).edit
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(ResourceOnlyTest.new(nil)).edit
    end
    assert_nil TestCruder.new(AllPolicyTest.new(nil)).edit
  end

  def test_create_is_authorized
    assert_raises(User::AccessDenied) do
      TestCruder.new(NonePolicyTest.new(nil)).create
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(ResourceOnlyTest.new(nil)).create
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(AccessOnlyTest.new(nil)).create
    end
    assert_nil TestCruder.new(AllPolicyTest.new(nil)).create
  end

  def test_update_is_authorized
    assert_raises(User::AccessDenied) do
      TestCruder.new(NonePolicyTest.new(nil)).update
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(ResourceOnlyTest.new(nil)).update
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(AccessOnlyTest.new(nil)).update
    end
    assert_nil TestCruder.new(AllPolicyTest.new(nil)).update
  end

  def test_destroy_is_authorized
    assert_raises(User::AccessDenied) do
      TestCruder.new(NonePolicyTest.new(nil)).destroy
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(ResourceOnlyTest.new(nil)).destroy
    end
    assert_raises(User::AccessDenied) do
      TestCruder.new(AccessOnlyTest.new(nil)).destroy
    end
    assert_nil TestCruder.new(AllPolicyTest.new(nil)).destroy
  end
end
