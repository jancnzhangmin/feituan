class Buyparamoption < ApplicationRecord
  belongs_to :buyparam
  has_many :indepotdetails, dependent: :destroy
  has_many :outdepotdetails, dependent: :destroy
  has_many :reportlostdetails, dependent: :destroy
  has_many :reportoverflowdetails, dependent: :destroy
end
