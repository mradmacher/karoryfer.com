class ApplicationController < ActionController::Base
	helper_method :current_artist, :current_artist?, :current_user, :current_user?, :current_user_session
  before_filter :redirect_subdomain
	before_filter :set_current_artist
  protect_from_forgery
  if Rails.env != 'test'
    rescue_from CanCan::AccessDenied, :with => Proc.new { redirect_to admin_login_url }
  end

	private
	def redirect_subdomain
		if request.subdomain.present?
      if request.subdomain != 'www'
        url = "#{request.protocol}www"
        url << request.host_with_port.gsub( "#{request.subdomain}", '' )
        url << "/#{request.subdomains.first}"
        url << request.fullpath unless request.fullpath == '/' 
        redirect_to url, :status => 301
      end
    elsif Rails.env != 'test'
      redirect_to "#{request.protocol}www.#{request.host_with_port}#{request.fullpath}", :status => 301
    end
	end

	def set_current_artist
		@current_artist = if params[:controller] == 'artists' 
			params[:id] ? Artist.find( params[:id] ) : nil
		else
			params[:artist_id] ? Artist.find( params[:artist_id] ) : nil
		end
	end

	def current_user_session
		return @current_user_session if defined?( @current_user_session )
		@current_user_session = UserSession.find
	end

	def current_artist
		@current_artist
	end

	def current_artist?
		!@current_artist.nil?
	end

	def current_user
		return @current_user if defined?( @current_user )
		@current_user = current_user_session && current_user_session.user
	end

	def current_user?
		!current_user.nil?
	end

	def require_user
		unless current_user
			raise CanCan::AccessDenied #redirect_to admin_login_url
		end
	end

	def require_no_user
		if current_user
			return false
		end
	end

end
