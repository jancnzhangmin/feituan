class Api::OrdersController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    orders = user.orders.order('id desc')
    orders = user.orders.where('paystatus = ? and deliverstatus = ?', 0, 0).order('id desc') if params[:type] == 'pay'
    orders = user.orders.where('paystatus = ? and deliverstatus = ?', 1, 0).order('paytime desc') if params[:type] == 'deliver'
    orders = user.orders.where('deliverstatus = ? and receivestatus = ?',1,0).order('id desc') if params[:type] == 'receive'
    orders = user.orders.where('receivestatus = ? and evaluatestatus = ?', 1, 0).order('id desc') if params[:type] == 'evaluate'
    if params[:type] == 'all'
      if params[:searchmode] == 'key'
        orders = []
        params[:searchkey].split(',').each do |f|
          if f == 'pay'
            orders = user.orders.where('paystatus = ?', 0).order('id desc')
          end
          if f == 'deliver'
            orders += user.orders.where('paystatus = ? and deliverstatus = ?', 1, 0).order('id desc')
          end
          if f == 'receive'
            orders += user.orders.where('deliverstatus = ? and receivestatus = ?', 1, 0).order('id desc')
          end
          if f == 'evaluate'
            orders += user.orders.where('receivestatus = ? and evaluatestatus = ?', 1, 0).order('id desc')
          end
          if f == 'finish'
            orders += user.orders.where('evaluatestatus = ?', 1).order('id desc')
          end
        end
      else
        orders = Order.where("ordernumber like ? or contact like ? or phone like ?","%#{params[:searchvalue]}%", "%#{params[:searchvalue]}%", "%#{params[:searchvalue]}%")
      end
    end
    orderarr = []
    orders.each do |order|
      orderdetailarr = []
      freight = 0
      freight = order.freight.amount if order.freight
      order.orderdetails.each do |f|
        product = f.product
        cover = product.cover.split('?')[0]
        cover = product.buyparams[0].buyparamoptions.where('id = ?', f.orderdetailcondition.buyoption_id).first.buyparamoptionimg.split('?')[0] if f.orderdetailcondition.buyoption_id != 0

        detail_param = {
            id: f.id,
            number: f.number,
            amount: f.price,
            product_id: f.product_id,
            cover: cover,
            name: product.name,
            buyparam: f.orderdetailcondition.buyparam,
            buyoption: f.orderdetailcondition.buyoption,
            evaluate: 0
        }
        orderdetailarr.push detail_param
      end
      orderdetailarr.sort!{ |a,b | a[:product_id] <=> b[:product_id]  }
      for i in 0..orderdetailarr.size - 1
        if orderdetailarr[i] && orderdetailarr[i + 1] && orderdetailarr[i][:product_id] == orderdetailarr[i + 1][:product_id]
          orderdetailarr[i][:evaluate] = 1
        end
        if Evaluate.where('order_id = ? and product_id = ?',order.id, orderdetailarr[i][:product_id]).size > 0
          orderdetailarr[i][:evaluate] = 1
        end
      end


      param = {
          order_id: order.id,
          amount: order.amount,
          ordernumber: order.ordernumber,
          paystatus: order.paystatus,
          deliverstatus: order.deliverstatus,
          receivestatus: order.receivestatus,
          evaluatestatus: order.evaluatestatus,
          summary: order.summary,
          orderdetails: orderdetailarr,
          freight: freight,
          province: order.province,
          city: order.city,
          district: order.district,
          address: order.address,
          contact: order.contact,
          phone: order.phone
      }
      orderarr.push param
    end

    return_api(orderarr)


    # id: f.id,
    #     number: f.number,
    #     amount: f.amount,
    #     producttype: f.producttype,
    #     product_id: f.product_id,
    #     name: product.name,
    #     cover: cover,
    #     buyparam_id: buycarcondition.buyparam_id,
    #     buyparam: buycarcondition.buyparam,
    #     buyoption_id: buycarcondition.buyoption_id,
    #     buyoption: buycarcondition.buyoption
  end

  def create
    user = User.find_by_token(params[:token])
    buycars = user.buycars
    if buycars.size > 0
      addr = Addr.find(params[:addr_id])
      order = user.orders.create(
          ordernumber: Time.now.strftime("%Y%m%d#{user.id.to_s}%H%M%S"),
          paystatus: 0,
          deliverstatus: 0,
          receivestatus: 0,
          evaluatestatus: 0,
          status: 1,
          summary: params[:summary],
          province: addr.province,
          city: addr.city,
          district: addr.district,
          address: addr.address,
          adcode: addr.adcode,
          contact: addr.contact,
          phone: addr.phone
          )
      amount = 0
      buycars.each do |buycar|
        orderdetail = order.orderdetails.create(product_id:buycar.product_id, number:buycar.number, price:buycar.amount, producttype:buycar.producttype)
        orderdetail.create_orderdetailcondition(buyparam_id: buycar.buycarcondition.buyparam_id, buyparam: buycar.buycarcondition.buyparam, buyoption_id: buycar.buycarcondition.buyoption_id, buyoption: buycar.buycarcondition.buyoption)
        amount += buycar.number * buycar.amount
      end
      order.update(amount: amount)
      order.create_freight(amount: 0)
      buycars.destroy_all
    else
      order = user.orders.last
    end
    return_api(JSON.parse(order.to_json))
  end

  def destroy
    order = Order.find(params[:id])
    order.destroy
    return_api('')
  end

  def pay
    user = User.find_by_token(params[:token])
    order = Order.find(params[:payorder_id])
    if params[:paytype] == 'weixin'
      user.charges.create(charge:order.amount, summary:'微信付款冲值')
    end
    user.charges.create(charge: -order.amount, summary:'付款', ordernumber:order.ordernumber)
    order.update(paystatus:1, paytime:Time.now)
    CaltaskJob.perform_later(order.id)
    return_api('')
  end

  def get_express
    order = Order.find(params[:order_id])
    orderdelivers = order.orderdelivers
    return_api(orderdelivers)
  end

  def confirmdeliver
    order = Order.find(params[:order_id])
    order.update(receivestatus: 1, receivetime:Time.now)
    IncomeJob.perform_later(order.id)
    return_api('')
  end

end
