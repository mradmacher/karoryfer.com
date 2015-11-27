require 'test_helper'
require_relative 'for_guest'
require_relative 'for_user'
require_relative 'for_artist_user'

module AbilityTest
  class ArtistUserTest < ActiveSupport::TestCase
    def setup
      @user = User.sham!
      @artist = Artist.sham!
      @album = Album.sham!

      @membership = Membership.sham!
      @account = @membership.user
      @account_artist = @membership.artist
      @account_album = Album.sham!(artist: @account_artist)
      @ability = Ability.new(@account)
    end

    include AbilityTest::ForGuest
    include AbilityTest::ForUser
    include AbilityTest::ForArtistUser

    def test_creating_artists_is_denied
      refute @ability.allows?(:write, :artist)
    end
  end
end
