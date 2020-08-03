class Orderprint < ApplicationRecord
  has_many :orderprintdetails, dependent: :destroy
end
