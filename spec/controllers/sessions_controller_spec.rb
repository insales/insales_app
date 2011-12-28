require 'spec_helper'

describe SessionsController do
  render_views

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  let :installed_app do
    MyApp.new(default_account.insales_subdomain, default_account.password)
  end

  describe "create" do
    it "should start account authorization" do
      get :create, :shop => installed_app.shop
      controller.send(:current_app).should be
      controller.send(:current_app).class.should == MyApp

      response.should redirect_to(installed_app.authorization_url)
    end
  end

  describe "autologin" do
    it "should authorize account" do
      installed_app.store_auth_token
      controller.stub!(:current_app).and_return(installed_app)

      get :autologin, :token => installed_app.auth_token
      controller.send(:current_app).should be_authorized

      response.should redirect_to(root_path)
    end
  end

  describe "destroy" do
    it "should clear session and redirect to login page" do
      installed_app.store_auth_token
      #destroy check authentication
      installed_app.authorize installed_app.auth_token
      controller.session[:app] = installed_app

      delete :destroy

      controller.session.should be_empty
      response.should redirect_to(login_path)
    end
  end
end
