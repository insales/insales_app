class MyApp < InsalesApi::App
  class << self
    def install shop, token, insales_id
      shop = self.prepare_shop shop
      return true if Account.find_by_insales_subdomain(shop)
      Account.create(
        :insales_subdomain  => shop,
        :password           => password_by_token(token),
        :insales_id         => insales_id
      )
    end

    def uninstall shop, password
      account = Account.find_by_insales_subdomain(self.prepare_shop(shop))
      return true unless account
      return false if account.password != password

      account.destroy
    end
  end
end