class Postalpolic < ApplicationRecord
  has_many :postalpolicareas, dependent: :destroy
end
