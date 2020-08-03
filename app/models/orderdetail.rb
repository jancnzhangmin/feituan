class Orderdetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :orderdetailcondition, dependent: :destroy
end
