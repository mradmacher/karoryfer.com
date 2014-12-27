require 'test_helper'

class TestResource
end

class TestPresenter < ResourcePresenter
  def _path
    'path'
  end

  def _edit_path
    'edit_path'
  end
end

class ResourcePresenterTest < ActiveSupport::TestCase
  def test_with_edit_path_yields_only_when_authorized
    resource = TestResource.new
    result = nil
    with_permission_to :write, resource do |abilities|
      TestPresenter.new(resource, abilities).with_edit_path { |path| result = path }
    end
    assert_equal 'edit_path', result
    result = nil
    without_permissions do |abilities|
      TestPresenter.new(resource, abilities).with_edit_path { |path| result = path }
    end
    assert_nil result
  end

  def test_with_show_path_yields_only_when_authorized
    resource = TestResource.new
    result = nil
    with_permission_to :read, resource do |abilities|
      TestPresenter.new(resource, abilities).with_show_path { |path| result = path }
    end
    assert_equal 'path', result
    result = nil
    without_permissions do |abilities|
      TestPresenter.new(resource, abilities).with_show_path { |path| result = path }
    end
    assert_nil result
  end

  def test_with_destroy_path_yields_only_when_authorized
    resource = TestResource.new
    result = nil
    with_permission_to :write, resource do |abilities|
      TestPresenter.new(resource, abilities).with_destroy_path { |path| result = path }
    end
    assert_equal 'path', result
    result = nil
    without_permissions do |abilities|
      TestPresenter.new(resource, abilities).with_destroy_path { |path| result = path }
    end
    assert_nil result
  end

  def test_edit_path_is_not_nil_when_authorized
    resource = TestResource.new
    with_permission_to :write, resource do |abilities|
      assert_equal 'edit_path', TestPresenter.new(resource, abilities).edit_path
    end
  end

  def test_edit_path_is_nil_when_not_authorized
    resource = TestResource.new
    without_permissions do |abilities|
      assert_nil TestPresenter.new(resource, abilities).edit_path
    end
  end

  def test_destroy_path_is_not_nil_when_authorized
    resource = TestResource.new
    with_permission_to :write, resource do |abilities|
      assert_equal 'path', TestPresenter.new(resource, abilities).destroy_path
    end
  end

  def test_destroy_path_is_nil_when_not_authorized
    resource = TestResource.new
    without_permissions do |abilities|
      assert_nil TestPresenter.new(resource, abilities).destroy_path
    end
  end

  def test_show_path_is_not_nil_when_authorized
    resource = TestResource.new
    with_permission_to :read, resource do |abilities|
      assert_equal 'path', TestPresenter.new(resource, abilities).show_path
    end
  end

  def test_show_path_is_nil_when_not_authorized
    resource = TestResource.new
    without_permissions do |abilities|
      assert_nil TestPresenter.new(resource, abilities).show_path
    end
  end
end
