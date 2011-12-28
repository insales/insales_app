require 'spec_helper'

describe MyApp do

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  describe 'install' do
    it 'should return true if successefuly install' do
      MyApp.install('my.shop.com', 'token', 1).should be_true
    end

    it 'should create new account' do
      lambda { MyApp.install('my.shop.com', 'token', 1) }.should change(Account, :count).by(1)
      account = Account.last

      account.insales_subdomain.should == 'my.shop.com'
      account.password.should          == MyApp.password_by_token('token')
      account.insales_id.should        == 1
    end

    it 'should return true if app already installed' do
      MyApp.install(default_account.insales_subdomain, 'token', 1).should be_true
    end

    it 'should no create new account if app already installed' do
      lambda { MyApp.install(default_account.insales_subdomain, 'token', 1) }.should change(Account, :count).by(0)
    end
  end

  describe 'uninstall' do
    it 'should destroy account' do
      MyApp.uninstall(default_account.insales_subdomain, default_account.password).should be_true
      Account.find_by_insales_subdomain(default_account.insales_subdomain).should_not be
    end

    it 'should not destroy account if password incorrect' do
      MyApp.uninstall(default_account.insales_subdomain, 'bad password').should be_false
      Account.find_by_insales_subdomain(default_account.insales_subdomain).should be
    end
  end
end