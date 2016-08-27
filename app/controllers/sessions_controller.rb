class SessionsController < ApplicationController
  skip_before_action :authentication, :configure_api, except: :destroy
  layout 'login'

  def show
    render action: :new
  end

  def create
    @shop = params[:shop]

    if account_by_params
      init_authorization account_by_params
    else
      flash.now[:error] = "Убедитесь, что адрес магазина указан правильно."
      render action: :new
    end
  end

  def autologin
    if current_app && current_app.authorize(params[:token])
      redirect_to location || root_path
    else
      redirect_to login_path
    end
  end

  def destroy
    logout
    redirect_to login_path
  end
end
