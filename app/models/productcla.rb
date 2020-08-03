class Productcla < ApplicationRecord
  has_and_belongs_to_many :products

  before_destroy :check_dependent

  private
  def check_dependent
    if self.products.size > 0
      errors[:base] << "分类下存在商品，不能删除"
      throw :abort
    end
  end
end
