require 'test_helper'

module SiteControllerTest
  class ForGuestTest < ActionController::TestCase
    def setup
      @controller = SiteController.new
      activate_authlogic
      @user = User.sham! :admin
      UserSession.create @user
    end
  end
end



