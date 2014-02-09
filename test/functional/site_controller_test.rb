require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  def test_get_home_succeeds
    get :home
    assert_response :success
  end

  def test_get_events_succeeds
    get :events
    assert_response :success
  end

  def test_get_posts_succeeds
    get :posts
    assert_response :success
  end

  def test_get_videos_succeeds
    get :videos
    assert_response :success
  end

  def test_get_albums_succeeds
    get :albums
    assert_response :success
  end

  def test_get_drafts_for_guest_is_denied
    assert_raises User::AccessDenied do
      get :drafts
    end
  end

  def test_get_drafts_for_user_displays_nothing
    login( User.sham! )
    albums = 3.times.to_a.map{ |i| Album.sham!( published: false ) }
    posts = 3.times.to_a.map{ |i| Post.sham!( published: false ) }
    events = 3.times.to_a.map{ |i| Event.sham!( published: false ) }
    get :drafts

    albums.each do |r|
      assert_select "a", {text: r.title, count: 0}
    end
    posts.each do |r|
      assert_select "a", {text: r.title, count: 0}
    end
    events.each do |r|
      assert_select "a", {text: r.title, count: 0}
    end
  end

  def test_get_drafts_for_artist_user_displays_drafts
    membership = Membership.sham!
    login( membership.user )
    albums = 3.times.to_a.map{ |i| Album.sham!( published: false, artist: membership.artist ) }
    posts = 3.times.to_a.map{ |i| Post.sham!( published: false, artist: membership.artist ) }
    events = 3.times.to_a.map{ |i| Event.sham!( published: false, artist: membership.artist ) }
    get :drafts

    albums.each do |r|
      assert_select "a", r.title
    end
    posts.each do |r|
      assert_select "a", r.title
    end
    events.each do |r|
      assert_select "a", r.title
    end
  end

  def test_get_drafts_for_artist_user_display_unpublished_albums_only_for_this_user
    membership = Membership.sham!
    login( membership.user )
    artist = membership.artist
    for_artist = []
    not_for_artist = []
    5.times { for_artist << Album.sham!( :unpublished, artist: artist ) }
    5.times { not_for_artist << Album.sham!( :unpublished ) }
    get :drafts
    for_artist.each do |a|
      assert_select 'a', a.title
    end
    not_for_artist.each do |a|
      assert_select '*', { text: a.title, count: 0 }
    end
  end
end

