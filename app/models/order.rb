class Order < ApplicationRecord
  has_many :profits, dependent: :destroy
  has_many :userincomes, dependent: :destroy
  has_many :usertasks, dependent: :destroy
  has_many :usersales, dependent: :destroy
  has_many :userrealsales, dependent: :destroy
  belongs_to :paytypes, optional: true
  has_one :freight, dependent: :destroy
  has_many :orderdetails, dependent: :destroy
  has_many :evaluates, dependent: :destroy
  belongs_to :user
  has_many :orderdelivers, dependent: :destroy

  after_save :cal_balance

  private

  def cal_balance
    user = self.user
    #withdrawal = user.withdrawals.sum('amount')
    charge = user.charges.sum('charge')
    user.balance = charge
    #order = user.orders.where('paystatus = ?',1).sum('amount')
    #user.balance = charge - withdrawal - order
    user.save
  end
end
