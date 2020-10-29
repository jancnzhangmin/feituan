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

  def wx_pay
    user = User.find_by_token(params[:token])
    order = Order.find(params[:payorder_id])
    body = order.orderdetails.map{|n|n.product.name}.join(' ')
    total_fee = order.amount * (getexchangerate)
    logger.info '======================================'
    logger.info getexchangerate
    payment_params = {
        body: body,
        out_trade_no: order.ordernumber,
        total_fee: (total_fee * 100).to_i,
        spbill_create_ip:  '127.0.0.1',
        notify_url: 'https://feituan.ysdsoft.com/api/orders/wxpay_notify',
        trade_type: 'JSAPI', # could be "JSAPI", "NATIVE" or "APP",
        openid: user.openid  # required when trade_type is `JSAPI`
    }
    result = WxPay::Service.invoke_unifiedorder(payment_params)
    $client ||= WeixinAuthorize::Client.new('wx9ba0afe3f3f1aa14', '92bdb66ae430c649d4ef4099fc5115f7')
    sign_package = $client.get_jssign_package(request.url.split('#')[0])
    if result.nil?
      #render html: "no"
    else
      pay_ticket_param = {
          timeStamp: sign_package["timestamp"],
          nonceStr: sign_package["nonceStr"],
          package: "prepay_id=#{result['prepay_id']}",  #这里一定注意，不仅仅是prepay_id，还需要拼接上“prepay_id=”
          signType: "MD5",
          appId: WxPay.appid,
          key: WxPay.key
      }
      pay_ticket_param = {
          paySign: WxPay::Sign.generate(pay_ticket_param)  #然后我们手动进行paySign计算
      }.merge(pay_ticket_param)
          param = {
          pay_ticket_param: pay_ticket_param,
          sign_package: sign_package
      }
      logger.info '====================================================='
      logger.info param.to_json
      logger.info result
      logger.info params[:url]
      logger.info '====================================================='
    return_api(param)
    end
  end

  def wxpay_notify
    result = Hash.from_xml(request.body.read)["xml"]
    if result['return_code']=='SUCCESS'
      order = Order.find_by_ordernumber(result['out_trade_no'])
      order.update(paystatus: 1, paytime: Time.now)
    end
    render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
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

  def getexchangerate
    exchangerate = Exchangerate.last
    if exchangerate && exchangerate.created_at + 1.days > Time.now
      rate = exchangerate.rate
    else
      conn = Faraday.new(:url => 'https://jisuhuilv.market.alicloudapi.com') do |faraday|
        faraday.request :url_encoded # form-encode POST params
        faraday.response :logger # log requests to STDOUT
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
      conn.headers[:Authorization] = 'APPCODE decb721f31db4b269706552df2724ecf'
      conn.params[:amount] = 1
      conn.params[:from] = 'PHP'
      conn.params[:to] = "CNY"
      request = conn.post do |req|
        req.url '/exchange/convert'
      end
      rate = JSON.parse(request.body)["result"]["rate"]
      Exchangerate.create(rate: rate)
    end
    rate
  end

  def getdelivertime
    isselect = 1
    deliverarr = []
    3.times do |i|
      if i == 0
        minarr = []
        minute_step = 0
        stime = ((Time.now + 40.minute).strftime('%Y-%m-%d %H:%M')[0..-2] + '0:00').to_time
        currenttime = stime
        while currenttime < Time.now.end_of_day do
          min_param = {
              value: currenttime.strftime('%H:%M'),
              isselect: isselect
          }
          minarr.push min_param
          minute_step += 1
          currenttime = stime + minute_step * 20.minutes
          isselect = 0
        end
        day_param = {
            title: (Time.now + i.days).strftime('%m月%d日'),
            data: minarr
        }
        deliverarr.push day_param
      else
        minarr = []
        minute_step = 0
        stime = (Time.now + i.days).beginning_of_day + 8.hour
        currenttime = stime
        while currenttime < (Time.now + i.days).end_of_day do
          min_param = {
              value: currenttime.strftime('%H:%M'),
              isselect: isselect
          }
          minarr.push min_param
          minute_step += 1
          currenttime = stime + minute_step * 20.minutes
          puts '====================='
          puts stime
          puts minute_step
        end
        day_param = {
            title: (Time.now + i.days).strftime('%m月%d日'),
            data: minarr
        }
        deliverarr.push day_param
      end
    end
    return_api(deliverarr)
    #(Time.now + 30.minute).strftime('%Y-%m-%d %H:%M')[0..-2] + '0:00'

  end

end
