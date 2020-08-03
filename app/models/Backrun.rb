class Backrun
  def self.create_quarter
    now = Time.now
    quarter = Quarter.where('begintime <= ? and endtime >= ?',now,now)
    if quarter.size == 0
      month = now.beginning_of_month.month - 1
      month = month / 3
      begintime = (now.strftime('%Y-') + (month * 3 + 1).to_s + '-1').to_time
      endtime = (begintime + 2.month).end_of_month
      quarter = Quarter.create(begintime: begintime, endtime: endtime, yearname: now.strftime('%Y'), name: (month + 1).to_s + '季度')
    else
      quarter = quarter.first
    end
    quarter
  end

  def self.get_useragentprice(userid,product_id)
    user = User.find(userid)
    agentprice = Product.find(product_id).price
    if user.isagent == 1
      quarter = create_quarter
      useragent = user.useragents.where('quarter_id = ?',quarter.id).first
      if !useragent
        useragent = user.useragents.create(agent_id: user.useragents.last.agent_id, quarter_id: quarter.id, name:quarter.name, examine:0)
      end
      agentprice = Agentprice.where('agent_id = ? and product_id = ?', useragent.agent_id, product_id)
      if agentprice.size > 0
        agentprice = agentprice.first.price
      else
        agentprice = Product.find(product_id).price
      end
    end
    agentprice
  end

  def self.caltask(userid,orderid)
    order = Order.find(orderid)
    user = User.find(userid)
    quarter = create_quarter
    agent = 0
    if user.isagent == 1
      useragent = user.useragents.where('quarter_id = ?',quarter.id).first
      agent = useragent.agent.id
    end
    orderdetails = order.orderdetails
    orderdetails.each do |f|
      amount = get_useragentprice(userid,f.product_id) * f.number
      amount = f.price * f.number if f.producttype == 1 && f.price > 0
      if Product.find(f.product_id).trial != 1
        user.usertasks.create(agent_id:agent, order_id:orderid, amount:amount)
      end
    end
    parentuser = user.parent
    if parentuser
      caltask(parentuser.id, orderid)
    end
  end

  def self.usersale(userid, orderid)
    order = Order.find(orderid)
    user = User.find(userid)
    orderdetails = order.orderdetails
    orderdetails.each do |f|
      if f.price > 0
        user.usersales.create(order_id: orderid, amount:f.price * f.number)
      end
    end
    parentuser = user.parent
    if parentuser
      usersale(parentuser.id, orderid)
    end
  end

  def self.userrealsale(userid, orderid)
    order = Order.find(orderid)
    user = User.find(userid)
    orderdetails = order.orderdetails
    orderdetails.each do |f|
      amount = get_useragentprice(userid,f.product_id) * f.number
      amount = f.price * f.number if f.producttype == 1 && f.price > 0
      if amount > 0
        user.userrealsales.create(order_id:orderid, amount:amount)
      end
    end
    parentuser = user.parent
    if parentuser
      userrealsale(parentuser.id, orderid)
    end
  end

  def self.userincome(userid, orderid, incomeamount)
    user = User.find(userid)
    parentuser = user.parent
    if parentuser
      order = Order.find(orderid)
      amount = 0
      orderdetails = order.orderdetails
      orderdetails.each do |f|
        amount += get_useragentprice(parentuser.id, f.product_id) * f.number
      end
      if amount < incomeamount
        parentuser.userincomes.create(order_id:orderid, amount:incomeamount - amount, status:0)
      end
      userincome(parentuser.id, orderid, amount)
    end
  end

  def self.income(orderid)
    order = Order.find(orderid)
    userincomes = order.userincomes
    userincomes.each do |f|
      f.status = 1
      f.save
    end
  end



end