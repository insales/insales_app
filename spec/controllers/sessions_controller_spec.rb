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
      SecureRandom.stub(:hex).and_return("55b8d109e4b07e985e80474fde68ade9")
      get :create, shop: installed_app.shop
      expect(controller.send(:current_app)).to be
      expect(controller.send(:current_app).class).to eq(MyApp)

      expect(response).to redirect_to(installed_app.authorization_url)
    end
  end

  describe "autologin" do
    it "should authorize account" do
      installed_app.auth_token
      controller.stub(:current_app).and_return(installed_app)

      get :autologin, token: installed_app.auth_token
      expect(controller.send(:current_app)).to be_authorized

      expect(response).to redirect_to(controller.root_path)
    end
  end

  describe "destroy" do
    it "should clear session and redirect to login page" do
      installed_app.auth_token
      #destroy check authentication
      installed_app.authorize installed_app.auth_token
      controller.session[:app] = installed_app

      delete :destroy

      expect(controller.session).to be_empty
      expect(response).to redirect_to(controller.login_path)
    end
  end
end
