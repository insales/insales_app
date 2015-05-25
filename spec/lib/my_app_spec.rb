require 'spec_helper'

describe MyApp do

  fixtures :accounts

  let :default_account do
    accounts(:default)
  end

  describe 'install' do
    it 'should return true if successefuly install' do
      expect(MyApp.install('my.shop.com', 'token', 1)).to eq(true)
    end

    it 'should create new account' do
      expect { MyApp.install('my.shop.com', 'token', 1) }.to change(Account, :count).by(1)
      account = Account.last

      expect(account.insales_subdomain).to eq('my.shop.com')
      expect(account.password).to          eq(MyApp.password_by_token('token'))
      expect(account.insales_id).to        eq(1)
    end

    it 'should return true if app already installed' do
      expect(MyApp.install(default_account.insales_subdomain, 'token', 1)).to eq(true)
    end

    it 'should no create new account if app already installed' do
      expect { MyApp.install(default_account.insales_subdomain, 'token', 1) }.to change(Account, :count).by(0)
    end
  end

  describe 'uninstall' do
    it 'should destroy account' do
      expect(MyApp.uninstall(default_account.insales_subdomain, default_account.password)).to eq(true)
      expect(Account.find_by(insales_subdomain: default_account.insales_subdomain)).not_to be
    end

    it 'should not destroy account if password incorrect' do
      expect(MyApp.uninstall(default_account.insales_subdomain, 'bad password')).to eq(false)
      expect(Account.find_by(insales_subdomain: default_account.insales_subdomain)).to be
    end
  end
end