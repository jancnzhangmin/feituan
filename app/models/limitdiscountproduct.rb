class Limitdiscountproduct < ApplicationRecord
  belongs_to :limitdiscount
  belongs_to :product
  has_many :limitdiscountlocks, dependent: :destroy
end
