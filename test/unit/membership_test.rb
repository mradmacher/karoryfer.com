require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  def test_validates_artist_presence
    membership = Membership.sham!( :build, artist: nil )
    refute membership.valid?
    assert membership.errors[:artist_id].include? I18n.t(
      'activerecord.errors.models.membership.attributes.artist_id.blank' )
  end

  def test_validates_user_presence
    membership = Membership.sham!( :build, user: nil )
    refute membership.valid?
    assert membership.errors[:user_id].include? I18n.t(
      'activerecord.errors.models.membership.attributes.user_id.blank' )
  end
end

