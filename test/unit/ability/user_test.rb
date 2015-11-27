require 'test_helper'
require_relative 'for_guest'
require_relative 'for_user'

module AbilityTest
  class UserTest < ActiveSupport::TestCase
    def setup
      @account = User.sham!
      @user = User.sham!
      @artist = Artist.sham!
      @album = Album.sham!
      @ability = Ability.new(@account)
    end

    include AbilityTest::ForGuest
    include AbilityTest::ForUser
  end
end
