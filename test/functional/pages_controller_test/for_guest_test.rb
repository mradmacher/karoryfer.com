require 'test_helper'

module PagesControllerTest
  class ForGuestTest < ActionController::TestCase
    def setup
      @controller = PagesController.new
    end

    def test_get_index_succeeds
      5.times{ Page.sham! }
      get :index
      assert_redirected_to page_url( Page.first )
    end

    def test_get_show_succeeds
      page = Page.sham!
      get :show, :id => page.to_param
      assert_response :success
    end

    def test_get_show_displays_headers
      page = Page.sham!
      get :show, :id => page.to_param
      assert_select "title", build_title( page.title )
      assert_select 'h1', page.title
    end
	end
end

