# frozen_string_literal: true

class MembershipPresenter < Presenter
  def_delegators(:resource, :artist, :user)

  def path
    admin_user_membership_path(resource.user, resource)
  end
end
