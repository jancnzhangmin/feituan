class CaltaskJob < ApplicationJob
  queue_as :default

  def perform(orderid)
    order = Order.find(orderid)
    user = order.user
    Backrun.caltask(user.id, order.id)
    Backrun.usersale(user.id, order.id)
    Backrun.userrealsale(user.id, order.id)

    orderdetails = order.orderdetails
    amount = 0
    orderdetails.each do |f|
      amount += Backrun.get_useragentprice(user.id,f.product_id) * f.number
    end
    Backrun.userincome(user.id,orderid,amount)

    # Do something later
  end
end
