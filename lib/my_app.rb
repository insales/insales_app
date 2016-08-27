class MyApp < InsalesApi::App
  class << self
    def install(shop, token, insales_id)
      shop = self.prepare_domain shop
      account = Account.find_by(insales_subdomain: shop)
      account.destroy if account
      Account.new(
        insales_subdomain: shop,
        password:          password_by_token(token),
        insales_id:        insales_id
      ).save
    end

    def uninstall(shop, password)
      account = Account.find_by(insales_subdomain: self.prepare_domain(shop))
      return true unless account
      return false if account.password != password

      account.destroy
      true
    end
  end
end
