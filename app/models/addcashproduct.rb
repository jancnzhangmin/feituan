class Addcashproduct < ApplicationRecord
  belongs_to :addcash
  belongs_to :product
  has_many :addcashlocks, dependent: :destroy
end
