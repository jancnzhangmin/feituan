class Indepot < ApplicationRecord
  has_many :indepotdetails, dependent: :destroy
end
