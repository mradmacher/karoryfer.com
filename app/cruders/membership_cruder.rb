# Provides access to membership resource.
class MembershipCruder < SimpleCruder
  attr_reader :user

  def initialize(abilities, params, user)
    super(abilities, params)
    @user = user
  end

  def find
    user.memberships.find(params[:id])
  end

  def build(attrs = {})
    user.memberships.new(attrs)
  end

  def search
    user.memberships
  end

  def permissions(action)
    case action
      when :index then [:read_membership, user]
      when :show then [:read_membership, user]
      when :new then [:write_membership, user]
      when :edit then [:write_membership, user]
      when :create then [:write_membership, user]
      when :update then [:write_membership, user]
      when :destroy then [:write_membership, user]
    end
  end

  def permitted_params
    strong_parameters.require(:membership).permit(:artist_id)
  end
end
