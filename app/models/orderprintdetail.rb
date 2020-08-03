class Orderprintdetail < ApplicationRecord
  belongs_to :orderprint
  belongs_to :orderproduct
end
