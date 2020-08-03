class Limitdiscount < ApplicationRecord
  has_many :limitdiscountusers, dependent: :destroy
  has_many :limitdiscountproducts, dependent: :destroy
end
