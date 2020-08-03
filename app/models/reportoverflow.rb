class Reportoverflow < ApplicationRecord
  has_many :reportoverflowdetails, dependent: :destroy
end
