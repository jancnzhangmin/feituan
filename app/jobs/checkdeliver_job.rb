class CheckdeliverJob < ApplicationJob
  queue_as :default

  def perform(orderid)
    order = Order.find(orderid)
    customer = '33BF8AE418809366438B75CDD747B10B'
    key = 'oWhaBhKc3008'
    order.orderdelivers.each do |deliver|
      param = '{"com":"' + deliver.com.to_s + '","num":"' + deliver.nu + '"}'
      sign = Digest::MD5.hexdigest(param + key + customer).upcase
      conn = Faraday.new(:url => 'http://poll.kuaidi100.com') do |faraday|
        faraday.request :url_encoded # form-encode POST params
        faraday.response :logger # log requests to STDOUT
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
      conn.params[:param] = param
      conn.params[:sign] = sign
      conn.params[:customer] = customer
      request = conn.post do |req|
        req.url '/poll/query.do'
      end
      result = JSON.parse(request.body)
      deliver.update(state:result["state"], ischeck:result["ischeck"], cdata:result["data"].to_json.to_s)
    end
    ischeck = 1
    order.orderdelivers.each do |f|
      if f.ischeck == 0
        ischeck = 0
      end
    end
    if ischeck == 1
      order.update(receivestatus:ischeck, receivetime:Time.now)
      Backrun.income(orderid)
    end
  end
end
