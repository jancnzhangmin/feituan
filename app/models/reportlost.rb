class Reportlost < ApplicationRecord
  has_many :reportlostdetails, dependent: :destroy
end
