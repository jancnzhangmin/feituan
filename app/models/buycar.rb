class Buycar < ApplicationRecord
  belongs_to :user
  has_one :buycarcondition, dependent: :destroy
  belongs_to :product
end
