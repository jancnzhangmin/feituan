class Admingroupauth < ApplicationRecord
  belongs_to :admingroup
  belongs_to :auth
end
