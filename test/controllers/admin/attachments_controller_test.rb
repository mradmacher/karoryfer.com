# frozen_string_literal: true

require 'test_helper'

class Admin::AttachmentsControllerTest < ActionController::TestCase
  def setup
    login_user
  end

  def test_delete_destroy_succeeds
    attachment = Attachment.sham!
    assert_equal 1, Attachment.count
    delete :destroy, params: { artist_id: attachment.album.artist.to_param, album_id: attachment.album.to_param, id: attachment.to_param }
    assert_equal 0, Attachment.count
    assert_response :redirect
  end

  def test_post_create_succeeds
    album = Album.sham!
    attributes = Attachment.sham!(:build, album: album).attributes.merge(
      file: Rack::Test::UploadedFile.new(File.open("#{FIXTURES_DIR}/attachments/att1.jpg"))
    )
    assert_equal 0, Attachment.count
    post :create, params: { artist_id: album.artist.to_param, album_id: album.to_param, attachment: attributes }
    assert_equal 1, Attachment.count
    assert_response :redirect
  end
end
