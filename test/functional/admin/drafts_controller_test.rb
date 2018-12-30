# frozen_string_literal: true

require 'test_helper'

class Admin::DraftsControllerTest < ActionController::TestCase
  def test_get_drafts_for_user_displays_drafts
    login_user
    albums = 3.times.to_a.map do
      Album.sham!(published: false)
    end
    get :index

    albums.each do |r|
      assert_select 'a', r.title
    end
  end
end
