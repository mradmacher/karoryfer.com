module ResourcesControllerTest
  module GetDrafts
    def test_get_drafts_for_guest_is_denied
      assert_raises User::AccessDenied do
        get :drafts
      end
    end

    def test_get_drafts_for_artist_user_displays_drafts
      membership = Membership.sham!
      login( membership.user )
      5.times { resource_class.sham!( published: false, artist: membership.artist ) }
      get :drafts
      resource_class.unpublished.each do |r|
        assert_select "a", r.title
      end
    end

    def test_get_drafts_for_artist_user_displays_drafts_only_for_given_artist
      membership = Membership.sham!
      login( membership.user )
      5.times { resource_class.sham!( published: false, artist: Artist.sham! ) }
      get :drafts
      resource_class.unpublished.each do |r|
        assert_select "a", {text: r.title, count: 0}
      end
    end
  end
end

