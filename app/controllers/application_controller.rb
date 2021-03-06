# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_artist,
                :current_artist?,
                :current_user,
                :current_user?,
                :current_user_session
  before_action :change_locale
  before_action :set_current_artist
  protect_from_forgery

  rescue_from User::AccessDenied, with: proc { redirect_to admin_login_url } unless %w[test development].include?(Rails.env)

  def current_user
    return @current_user if defined?(@current_user)

    current_user = current_user_session&.user
    @current_user = CurrentUserPresenter.new(current_user) if current_user
  end

  def change_locale
    I18n.locale = locale_from_params || locale_from_cookies || locale_from_header || I18n.default_locale
  end

  private

  attr_reader :current_artist

  def locale_from_params
    return unless params.key?(:l)

    l = params[:l].to_s.downcase.strip.to_sym
    cookies.permanent[:karoryfer_locale] = l if I18n.available_locales.include?(l)
  end

  def locale_from_cookies
    return unless cookies[:karoryfer_locale]

    l = cookies[:karoryfer_locale].to_sym
    l if I18n.available_locales.include?(l)
  end

  def locale_from_header
    http_accept_language.compatible_language_from(I18n.available_locales)
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

  def current_artist?
    !@current_artist.nil?
  end

  def current_user?
    !current_user.nil?
  end

  def authorize(permitted)
    raise User::AccessDenied unless permitted
  end

  def validate(resource)
    raise InvalidResource, resource unless yield resource
  end

  protected

  def set_layout
    current_artist? ? 'current_artist' : 'application'
  end
end
