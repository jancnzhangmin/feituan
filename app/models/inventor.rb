class Inventor < ApplicationRecord
  has_many :inventordetails, dependent: :destroy
end
