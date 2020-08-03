class Agent < ApplicationRecord
  has_many :agentprices, dependent: :destroy
  has_many :usertasks, dependent: :destroy
  has_many :useragents, dependent: :destroy

  after_create :create_corder

  private
  def create_corder
    self.update(corder: self.id)
  end
end
