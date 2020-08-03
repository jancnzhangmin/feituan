class Indepotdetail < ApplicationRecord
  belongs_to :indepot
  belongs_to :product
  belongs_to :buyparamoption, optional: true

  after_save :create_cost
  after_destroy :create_cost

  private
  def create_cost
    indepot = self.indepot.reload
    cost = indepot.indepotdetails.map{|n|n.cost * n.number}.reduce(:+)
    cost = 0 if !cost
    if cost != indepot.cost
      indepot.cost = cost
      indepot.save
    end
  end
end
