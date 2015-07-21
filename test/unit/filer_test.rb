require 'test_helper'

class FilerTest < ActiveSupport::TestCase
  def setup
    FileUtils.mkdir('/tmp/filertest')
  end

  def teardown
    FileUtils.remove_dir('/tmp/filertest', true)
  end

  def test_lists_all_entries_from_given_dir
    FileUtils.touch('/tmp/filertest/a.wav')
    FileUtils.touch('/tmp/filertest/b.pdf')
    FileUtils.touch('/tmp/filertest/c')
    FileUtils.mkdir('/tmp/filertest/subdir')
    FileUtils.touch('/tmp/filertest/subdir/ab.c')

    filer = Uploader::Filer.new('/tmp/filertest')
    list = filer.list
    assert_equal 4, list.size
    assert list.include?('a.wav')
    assert list.include?('b.pdf')
    assert list.include?('c')
    assert list.include?('subdir/ab.c')
  end

  def test_returns_full_path_to_file_from_list
    FileUtils.mkdir('/tmp/filertest/subdir')
    FileUtils.touch('/tmp/filertest/subdir/a.wav')

    filer = Uploader::Filer.new('/tmp/filertest')
    assert_equal '/tmp/filertest/subdir/a.wav', filer.path_to('subdir/a.wav')
  end

  def test_does_not_return_path_to_file_not_on_list
    FileUtils.touch('/tmp/filertest/a.wav')

    filer = Uploader::Filer.new('/tmp/filertest')
    assert_nil filer.path_to('../secret')
  end
end
