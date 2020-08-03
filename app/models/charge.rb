class Charge < ApplicationRecord
  belongs_to :user

  after_save :cal_balance

  private

  def cal_balance
    user = self.user
    #withdrawal = user.withdrawals.sum('amount')
    charge = user.charges.sum('charge')
    #order = user.orders.where('paystatus = ?',1).sum('amount')
    user.balance = charge
    user.save
  end

end
