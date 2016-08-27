class InsalesAppController < ApplicationController
  skip_before_action :authentication
  skip_before_action :configure_api

  def install
    raise "Fail to install" unless MyApp.install params[:shop], params[:token], params[:insales_id]
    head :ok
  end

  def uninstall
    raise "Fail to uninstall" unless MyApp.uninstall params[:shop], params[:token]
    head :ok
  end
end
