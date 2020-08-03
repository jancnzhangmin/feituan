class Admin < ApplicationRecord
  has_and_belongs_to_many :admingroups
end
