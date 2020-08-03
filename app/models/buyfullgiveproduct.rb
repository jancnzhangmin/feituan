class Buyfullgiveproduct < ApplicationRecord
  belongs_to :buyfull
  belongs_to :product
  has_many :buyfulllocks, dependent: :destroy
end
