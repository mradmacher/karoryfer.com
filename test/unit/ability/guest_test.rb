require 'test_helper'
require_relative 'for_guest'

class Ability::GuestTest < ActiveSupport::TestCase
  def setup
    @artist = Artist.sham!
    @album = Album.sham!
    @user = User.sham!
    @ability = Ability.new(nil)
  end

  include Ability::ForGuest
end
