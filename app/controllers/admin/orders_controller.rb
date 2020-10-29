class Admin::OrdersController < ApplicationController
  require 'net/http'
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      orders = Order.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      orders = Order.all.order('created_at desc')
    end

    if params[:filterchk]
      data = JSON.parse(params[:filterchk])
      condition = []
      condition.push 'paystatus = 0' if data.include? '待付'
      condition.push '(paystatus = 1 and deliverstatus = 0)' if data.include? '待发'
      condition.push '(deliverstatus = 1 and receivestatus = 0)' if data.include? '待收'
      condition.push 'receivestatus = 1 and evaluatestatus = 0' if data.include? '待评价'
      condition.push 'status = 0' if data.include? '异常'
      orders = Order.where(condition.join(' or '))
      #orders = orders.or(orders.where('paystatus = ? and deliverstatus = ?', 1, 0)) if data.include? '待发'
      # orders = orders.where('deliverstatus = ? and receivestatus = ?', 1, 0) if data.include? '待收'
      # orders = orders.where('receivestatus = ? and evaluatestatus = ?', 1, 0) if data.include? '待评价'
      # orders = orders.where('status = ?', 0) if data.include? '异常'
    end
    if params[:filtername]
      usersid = User.where("name like '%#{params[:filtername]}%' or nickname like '#{params[:filtername]}'").ids
      realname = Realname.where("phone like '%#{params[:filtername]}%'").map{|n|n.user_id}
      usersid += realname
      usersid.push 0
      usersid.uniq!
      orders = orders.where("ordernumber like '#{params[:filtername]}' or user_id in (?) or contact like'%#{params[:filtername]}%' or phone like '%#{params[:filtername]}%'",usersid)
    end
    if params[:filterdate].to_s.size > 0
      orders = orders.where('created_at between ? and ?', DateTime.parse(params[:filterdate][0]), DateTime.parse(params[:filterdate][1]).end_of_day)
    end
    orders = orders.page(params[:page]).per(params[:per])
    orderarr = []
    orders.each do |f|
      paystatus = '待支付'
      paystatus = '已支付' if f.paystatus == 1
      deliverstatus = '待发货'
      deliverstatus = '已发货' if f.deliverstatus == 1
      receivestatus = '待收货'
      receivestatus = '已收货' if f.receivestatus == 1
      evaluatestatus = '待评价'
      evaluatestatus = '已评价' if f.evaluatestatus == 1
      paytime = ''
      f.paytime.strftime('%Y-%m-%d %H:%M:%S') if f.paytime
      delivertime = ''
      delivertime = f.delivertime.strftime('%Y-%m-%d %H:%M:%S') if f.delivertime
      receivetime = ''
      receivetime = f.receivetime.strftime('%Y-%m-%d %H:%M:%S') if f.receivetime
      name = f.user.nickname.to_s
      name = f.user.name if f.user.name.to_s.size > 0
      param ={
          id: f.id,
          ordernumber: f.ordernumber,
          paystatus: f.paystatus,
          paytime: paytime,
          deliverstatus: f.deliverstatus,
          delivertime: delivertime,
          receivestatus: f.receivestatus,
          receivetime: receivetime,
          evaluatestatus: f.evaluatestatus,
          amount: ActiveSupport::NumberHelper.number_to_currency(f.amount,unit:''),
          province: f.province,
          city: f.city,
          district: f.district,
          address: f.address,
          name: name,
          contact: f.contact,
          phone: f.phone
      }
      orderarr.push param
    end
    param = {
        data:orderarr,
        total:orders.total_count
    }
    return_res(param)
  end

  def show
    order = Order.find(params[:id])
    freight =  order.freight
    orderdetails = order.orderdetails
    orderdetailarr = []
    amount = 0
    orderdetails.each do |f|
      param = {
          outdepot: 1,
          id: f.id,
          product: Product.find(f.product_id).name,
          buyparam: f.orderdetailcondition.buyparam,
          buyoption: f.orderdetailcondition.buyoption,
          number: f.number,
          price: ActiveSupport::NumberHelper.number_to_currency(f.price,unit:''),
          amount: ActiveSupport::NumberHelper.number_to_currency(f.number * f.price,unit:''),
          summary: ''
      }
      amount += f.number * f.price
      orderdetailarr.push param
    end

    param = {
        outdepot: -1,
        id: freight.id,
        product:'合计',
        buyparam: '',
        buyoption: '',
        number: '',
        price: '',
        amount: ActiveSupport::NumberHelper.number_to_currency(amount, unit:'')
    }
    orderheaders = {
        orderdate: order.updated_at.strftime('%Y-%m-%d'),
        ordernumber: order.ordernumber,
        address: order.province.to_s + order.city.to_s + order.district.to_s + order.address.to_s,
        contact: order.contact,
        phone: order.phone,
        expressnumber: order.orderdelivers.map{|n|n.nu}.join(' '),
        numbercount: order.orderdetails.sum('number') + order.orderdelivers.size
    }

    orderdelivers = order.orderdelivers
    orderdeliverarr = []
    orderdelivers.each do |f|
      orderdeliver_params ={
          id:f.id,
          state: f.state,
          ischeck: f.ischeck,
          com: f.com,
          nu: f.nu,
          cdata: f.cdata,
          company: f.company,
          eleimg: f.eleimg.url
      }
      orderdeliverarr.push orderdeliver_params
    end

    orderdetailarr.push param
    expresscompany = Expresscode.all
    param = {
        orders: orderdetailarr,
        expresscompany: expresscompany,
        delivers: orderdeliverarr,
        orderheaders: orderheaders
    }
    return_res(param)
  end


  def autonumber
    uri = URI("http://www.kuaidi100.com/autonumber/auto?num=#{params[:num]}&key=oWhaBhKc3008")
    response = Net::HTTP.get(uri)
    comcodearr = []
    JSON.parse(response).each do |f|
      comcode = Expresscode.find_by_comcode(f["comCode"])
      comcodearr.push comcode
    end
    return_res(comcodearr)
  end

  def createdeliver
    order = Order.find(params[:order_id])
    if order.deliverstatus == 0
      order.update(deliverstatus:1, delivertime:Time.now)
    end
    expresscode =  Expresscode.find_by_comcode(params[:com])
    order.orderdelivers.create(state:-1, ischeck:0, com:params[:com], nu:params[:nu], company:expresscode.company)
    CheckdeliverJob.perform_later(order.id)
    return_res(order.orderdelivers)
  end

  def deletedeliver
    orderdeliver = Orderdeliver.find(params[:id])
    order = orderdeliver.order
    orderdeliver.destroy
    return_res(order.orderdelivers)
  end

  def createele
    # if Elesheet.all.size == 0
    #   get_elesheet
    # end

    order = Order.find(params[:id])
    stamp = Time.now.to_i
    param = {
        type: "10",
        partnerId: '2204170679601',
        partnerKey: 'Q1VMRThZSzNZSzZDU3lWNTRzYnVCY2M5cHlVT0lKOFRGWHhsQzhPY0lJTG9pVW5UdmtlazlRQyt3Q1crSTFiUg==',
        net:'cainiao',
        kuaidicom:'yuantong',
        recManName: order.contact,
        recManMobile: order.phone,
        recManPrintAddr: order.province.to_s + order.city.to_s + order.district.to_s + order.address.to_s,
        sendManName: Setting.first.sendmanname,
        sendManMobile: Setting.first.sendmanmobile,
        sendManPrintAddr: Setting.first.sendmanprintaddr,
        tempid: 'c9c980886e6141a0b4f82316aafffb1a',
        cargo: order.orderdetails.map{|n|n.product.name}.uniq.join(' '),
        count: "1"
    }
    sign =  Digest::MD5.hexdigest(param.to_json + stamp.to_s + Setting.first.kuaidikey + Setting.first.kuaidisecret).upcase
    conn = Faraday.new(:url => 'https://poll.kuaidi100.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    # conn.headers[:apikey] = '6e1802f8c0cd1b42b32249ba42c2e602'
    conn.params[:method] = 'getPrintImg'
    conn.params[:key] = Setting.first.kuaidikey
    conn.params[:sign] = sign
    conn.params[:t] = stamp
    conn.params[:param] = param.to_json
    request = conn.post do |req|
      req.url '/printapi/printtask.do'
    end
    orderdeliver = JSON.parse(request.body)["data"]
    company = Expresscode.find_by_comcode(orderdeliver["kuaidicom"])
    img = "data:image/jpeg;base64," + JSON.parse(orderdeliver["imgBase64"])[0].delete("\n")
    order.orderdelivers.create(state:0, ischeck:0, com:orderdeliver["kuaidicom"], nu:orderdeliver["kuaidinum"], company:company.company, eleimg:img)
    return_res(order.orderdelivers.last.eleimg.url)
  end

  def set_elesheet
    #logger.info reponse
  end



  private
  def get_elesheet
    stamp = Time.now.to_i
    param = {
        net: 'cainiao',
        callBackUrl: 'https://feituan.ysdsoft.com/admin/orders/set_elesheet',
        partnerId: ''
    }
    sign = Digest::MD5.hexdigest(param.to_json + stamp.to_s + Setting.first.kuaidikey + Setting.first.kuaidisecret).upcase
    conn = Faraday.new(:url => 'https://poll.kuaidi100.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:key] = Setting.first.kuaidikey
    conn.params[:sign] = sign
    conn.params[:t] = stamp
    conn.params[:param] = param.to_json
    request = conn.post do |req|
      req.url '/printapi/authThird.do'
    end
  end


end
