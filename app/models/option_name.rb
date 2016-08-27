class OptionName < ActiveRecord::Base
  belongs_to :product
  validates :insales_option_id, presence: true
end
