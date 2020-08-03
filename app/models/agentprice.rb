class Agentprice < ApplicationRecord
  belongs_to :agent
  belongs_to :product
end
