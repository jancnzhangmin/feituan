class Seller < ApplicationRecord
  acts_as_mappable
  has_secure_password
  has_and_belongs_to_many :delivermodes
  has_many :shophours
end
