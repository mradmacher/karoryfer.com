require 'test_helper'
require_relative 'for_user'
require_relative 'for_artist_user'

module AbilityTest
  class AdminTest < ActiveSupport::TestCase
    def setup
      @user = User.sham!
      @artist = Artist.sham!
      @album = Album.sham!
      @membership = Membership.sham!
      @account = @membership.user
      @account.update_attributes(admin: true)
      @account_artist = @membership.artist
      @account_album = Album.sham!(artist: @account_artist)
      @ability = Ability.new(@account)
    end

    include AbilityTest::ForUser
    include AbilityTest::ForArtistUser

    def test_creating_artist_as_admin_is_allowed
      assert @ability.allows?(:write, :artist)
    end

    def test_accessing_user_resources_as_admin_is_allowed
      assert @ability.allows?(:read, :user)
      assert @ability.allows?(:read, @user)
      assert @ability.allows?(:read_membership, @user)
    end

    def test_managing_user_resources_as_admin_is_allowed
      assert @ability.allows?(:write, :user)
      assert @ability.allows?(:write, @user)
      assert @ability.allows?(:write_membership, @user)
    end
  end
end
