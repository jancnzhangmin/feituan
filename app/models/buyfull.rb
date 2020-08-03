class Buyfull < ApplicationRecord
  has_many :buyfullusers, dependent: :destroy
  has_many :buyfullproducts, dependent: :destroy
  has_many :buyfullgiveproducts, dependent: :destroy
end
