class Depot < ApplicationRecord
  belongs_to :product

  after_save :cal_total

  private
  def cal_total
    total = self.cost * self.number
    if total != self.total
      self.total = total
      self.save
    end
  end
end
