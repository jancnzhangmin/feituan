class Examine < ApplicationRecord
  has_many :userpastrecords, dependent: :destroy
end
