# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_account # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_action :authentication, :configure_api

  protected

  def authentication
    logout if enter_from_different_shop?

    if current_app && current_app.authorized?
      return if (@account = Account.find_by(insales_subdomain: current_app.shop))
    end

    store_location

    if account_by_params
      init_authorization account_by_params
    else
      redirect_to login_path
    end
  end

  def logout
    reset_session
  end

  def configure_api
    current_app.configure_api
  end

  def init_authorization(account)
    session[:app] = MyApp.new(account.insales_subdomain, account.password)

    redirect_to session[:app].authorization_url
  end

  def store_location(path = nil)
    session[:return_to] = path || request.fullpath
  end

  def location
    session[:return_to]
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def enter_from_different_shop?
    current_app && !params[:shop].blank? && params[:shop] != current_app.shop
  end

  def account_by_params
    @account ||=
      if params[:insales_id]
        Account.find_by insales_id: params[:insales_id]
      else
        Account.find_by insales_subdomain: params[:shop]
      end
  end

  def current_app
    session[:app]
  end

  def current_account
    @account
  end
end
