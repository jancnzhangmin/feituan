class ApplicationController < ActionController::API

  def return_res(result, status = 10000, msg = 'OK')
    #sign = Digest::SHA1.hexdigest(signature(result).map{|n|n}.join(','))
    param = {
        status: status,
        msg: msg,
        #sign: sign,
        result: result
    }
    render json: param.to_json,content_type: "application/javascript"
  end

  def return_api(result, status = 10000, msg = 'OK')
    if result.class == String
      sign = Digest::SHA1.hexdigest(result)
    else
      sign = Digest::SHA1.hexdigest(result.map{|n|n}.join(','))
    end
    param = {
        status: status,
        msg: msg,
        sign: sign,
        result: result
    }
    render json: param.to_json,content_type: "application/javascript"
  end

  def create_quarter
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

  def get_useragentprice(user,product_id)
    quarter = create_quarter
    useragent = user.useragents.where('quarter_id = ?',quarter.id).first
    # if !useragent
    #   useragent = user.useragents.create(agent_id: user.useragents.last.agent_id, quarter_id: quarter.id, name:quarter.name, examine:0)
    # end
    if useragent
    agentprice = Agentprice.where('agent_id = ? and product_id = ?', useragent.agent_id, product_id)
    else
      agentprice = []
    end
    if agentprice.size > 0
      agentprice = agentprice.first.price
    else
      agentprice = Product.find(product_id).price
    end
    agentprice
  end

  def formattime(time)
    formatt = ''
    subtime = (Time.now - time).to_i
    if subtime / 60 < 1
      formatt = '刚刚'
    elsif subtime / 60 < 60
      formatt = (subtime / 60).to_s + '分钟前'
    elsif subtime / 60 / 60 < 24
      formatt = (subtime / 60 / 60).to_s + '小时前'
    else
      formatt = time.strftime('%Y-%m-%d %H:%M:%S')
    end
    formatt
  end




end
