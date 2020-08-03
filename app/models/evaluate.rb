class Evaluate < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_many :evaluateimgs, dependent: :destroy
end
