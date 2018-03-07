class MembershipsController < CurrentUserController
  def index
    @presenters = MembershipPresenter.presenters_for(cruder.index)
  end

  def show
    @presenter = MembershipPresenter.new(cruder.show)
  end

  def edit
    @presenter = MembershipPresenter.new(cruder.edit)
    render :edit
  end

  def new
    @presenter = MembershipPresenter.new(cruder.new)
    render :new
  end

  def update
    redirect_to MembershipPresenter.new(cruder.update).path
  rescue Crudable::InvalidResource => e
    @presenter = MembershipPresenter.new(e.resource)
    render :edit
  end

  def create
    redirect_to admin_user_url(cruder.create.user)
  rescue Crudable::InvalidResource => e
    @presenter = MembershipPresenter.new(e.resource)
    render :new
  end

  def destroy
    redirect_to admin_user_url(cruder.destroy.user)
  end

  private

  def policy_class
    MembershipPolicy
  end

  def cruder
    MembershipCruder.new(policy_class.new(current_user.resource), params, @user_presenter.resource)
  end
end
