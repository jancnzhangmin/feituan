class Buyparam < ApplicationRecord
  belongs_to :product
  has_many :buyparamoptions, dependent: :destroy
end
