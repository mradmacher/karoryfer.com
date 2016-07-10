# Provides access to user resource.
class UserCruder < SimpleCruder
  def list
    User.all
  end

  def find
    User.find(params[:id])
  end

  def build
    User.new
  end

  def permitted_params
    fields = [:login, :email, :password, :password_confirmation]
    fields.concat([:admin, :publisher]) if policy.write_access?
    strong_parameters.require(:user).permit(fields)
  end
end
