require 'test_helper'
require_relative 'for_guest'
require_relative 'for_user'

class Ability::UserTest < ActiveSupport::TestCase
  def setup
    @account = User.sham!
    @user = User.sham!
    @artist = Artist.sham!
    @album = Album.sham!
    @ability = Ability.new(@account)
  end

  include Ability::ForGuest
  include Ability::ForUser
end
