class OptionValue < ActiveRecord::Base
  validates :insales_option_value_id, presence: true
  belongs_to :variant
end
