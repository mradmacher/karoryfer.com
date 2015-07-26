class ApplicationController < ActionController::Base
  helper_method :current_artist, :current_artist?, :current_user, :current_user?, :current_user_session
  before_filter :redirect_subdomain
  before_filter :set_current_artist
  protect_from_forgery
  rescue_from User::AccessDenied, :with => Proc.new { redirect_to admin_login_url } if Rails.env != 'test'

  helper_method :can?

  def abilities=(abilities)
    @abilities = abilities
  end

  def abilities
    @abilities ||= Ability.new(current_user)
  end

  protected

  def can?(action, subject)
    abilities.allow?(action, subject)
  end

  def authorize!(action, subject)
    raise User::AccessDenied unless abilities.allowed?(action, subject)
  end

  private

  def redirect_subdomain
    if request.subdomain.present?
      if Artist.pluck(:reference).include? request.subdomain
        url = "#{request.protocol}www"
        url << request.host_with_port.gsub( "#{request.subdomain}", '' )
        url << "/#{request.subdomains.first}"
        url << request.fullpath unless request.fullpath == '/'
        redirect_to url, :status => 301
      end
    end
  end

  def set_current_artist
    @current_artist = if params[:controller] == 'artists'
      params[:id] ? Artist.find_by_reference(params[:id]) : nil
    else
      params[:artist_id] ? Artist.find_by_reference(params[:artist_id]) : nil
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_artist
    @current_artist
  end

  def current_artist?
    !@current_artist.nil?
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def current_user?
    !current_user.nil?
  end

  def require_user
    raise User::AccessDenied unless current_user
  end

  def require_no_user
    if current_user
      return false
    end
  end

  protected

  def set_layout
    current_artist?? 'current_artist' : 'application'
  end
end
