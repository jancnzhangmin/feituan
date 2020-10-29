class Api::UserlocationController < ApplicationController
  def getnear
    user = User.find_by_token(params[:token])
    conn = Faraday.new(:url => 'https://apis.map.qq.com') do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    conn.params[:boundary] = "nearby(#{params[:lat]},#{params[:lng]},1000)"
    conn.params[:key] = 'BZMBZ-MK7KS-GYZOI-6CUVK-CWMBF-C7F5Y'
    conn.params[:oversea] = '1'
    conn.params[:language] = 'en'
    request = conn.get do |req|
      req.url '/ws/place/v1/search'
    end
    data = JSON.parse(request.body)["data"]
    return_api(data)
  end

  def setcity
    user = User.find_by_token(params[:token])
    user.update(city: params[:city])
    return_api('')
  end
end
