class Productbanner < ApplicationRecord
  belongs_to :product
  after_create :create_corder

  private
  def create_corder
    self.corder = self.id
    self.save
  end
end
