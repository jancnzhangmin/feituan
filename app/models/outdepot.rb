class Outdepot < ApplicationRecord
  has_many :outdepotdetails, dependent: :destroy
end
