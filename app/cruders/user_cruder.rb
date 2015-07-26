# Provides access to user resource.
class UserCruder < SimpleCruder
  def find
    User.find(params[:id])
  end

  def build(attrs = {})
    User.new(attrs)
  end

  def search
    User.all
  end

  def permissions(action)
    case action
      when :index then [:read, :user]
      when :show then [:read, find]
      when :new then [:write, :user]
      when :edit then [:write, find]
      when :create then [:write, :user]
      when :update then [:write, find]
      when :destroy then [:write, find]
    end
  end

  def permitted_params
    fields = [:login, :email, :password, :password_confirmation]
    if abilities.allow? :write, :user
      fields.concat([:admin, :publisher])
    end
    strong_parameters.require(:user).permit(fields)
  end
end
