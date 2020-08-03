class Reportlostdetail < ApplicationRecord
  belongs_to :reportlost
  belongs_to :buyparamoption
  belongs_to :product
end
