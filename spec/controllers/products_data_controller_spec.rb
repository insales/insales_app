require 'spec_helper'

describe ProductsDataController do
  render_views

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  let :installed_app do
    MyApp.new(default_account.insales_subdomain, default_account.password)
  end

  describe "#update" do
    before do
      controller.stub(:authentication)
      controller.stub(:current_account) { default_account }
      controller.stub(:configure_api)
    end
    it "starts updating through delayed jobs" do
      get :update

      expect(response).to redirect_to(products_path)
      expect(flash[:notice]).to be_present
      expect(Delayed::Job.count).to eq(1)
    end
  end
end
