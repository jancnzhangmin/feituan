class Outdepotdetail < ApplicationRecord
  belongs_to :outdepot
  belongs_to :product
  belongs_to :buyparamoption
end
