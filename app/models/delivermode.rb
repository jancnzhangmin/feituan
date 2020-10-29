class Delivermode < ApplicationRecord
  has_and_belongs_to_many :sellers
  has_and_belongs_to_many :products
end
