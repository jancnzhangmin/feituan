class Addcash < ApplicationRecord
  has_many :addcashproducts, dependent: :destroy
    #has_many :addcashgives, dependent: :destroy
     has_many :addcashgis, dependent: :destroy
  has_many :addcashusers, dependent: :destroy
end
