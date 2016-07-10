# Provides access to membership resource.
class MembershipCruder < SimpleCruder
  alias_method :user, :context

  def list
    user.memberships
  end

  def find
    user.memberships.find(params[:id])
  end

  def build
    user.memberships.new(permitted_params)
  end

  def permitted_params
    strong_parameters.require(:membership).permit(:artist_id)
  end
end
