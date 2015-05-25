require 'spec_helper'

describe InsalesAppController do
  render_views

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  describe 'install' do
    it "should call install for MyApp" do
      MyApp.stub(:install).and_return true
      get :install, token: 'token', shop: 'my.shop.com', insales_id: 1
      expect(response.status).to eq(200)
    end

    it "should raise error if cant install" do
      MyApp.stub(:install).and_return false
      expect { get :install, token: 'token', shop: 'my.shop.com', insales_id: 1 }.to raise_error
    end
  end

  describe 'uninstall' do
    it "should call uninstall for MyApp" do
      MyApp.stub(:uninstall).and_return true
      get :uninstall, token: 'token'
      expect(response.status).to eq(200)
    end

    it "should raise error if cant install" do
      MyApp.stub(:uninstall).and_return false
      expect { get :uninstall, token: 'token' }.to raise_error
    end
  end
end