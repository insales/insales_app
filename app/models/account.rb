class Account < ActiveRecord::Base
  validates_presence_of :insales_id
  validates_presence_of :insales_subdomain
  validates_presence_of :password
end
