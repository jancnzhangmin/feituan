class IncomeJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    Backrun.income(order_id)
    # Do something later
  end
end
