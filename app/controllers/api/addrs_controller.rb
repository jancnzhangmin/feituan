class Api::AddrsController < ApplicationController
  require 'net/http'
  def index
    user = User.find_by_token(params[:token])
    addrs = user.addrs.order('id desc')
    return_api(addrs)
  end

  def create
    user = User.find_by_token(params[:token])
    user.addrs.create(
        contact:params[:data][:contact],
        phone: params[:data][:phone],
        province: params[:data][:province],
        city: params[:data][:city],
        district: params[:data][:district],
        adcode: params[:data][:adcode],
        address: params[:data][:address]
        )
    return_api('')
  end

  def update
    addr = Addr.find(params[:id])
    addr.update(
        contact:params[:data][:contact],
        phone: params[:data][:phone],
        province: params[:data][:province],
        city: params[:data][:city],
        district: params[:data][:district],
        adcode: params[:data][:adcode],
        address: params[:data][:address]
    )
    return_api('')
  end

  def show
    addr = Addr.find(params[:id])
    return_api(JSON.parse(addr.to_json))
  end

  def destroy
    addr = Addr.find(params[:id])
    addr.destroy
    return_api('')
  end

  def getadcode
    uri = URI("https://restapi.amap.com/v3/geocode/geo?address=#{URI.encode(params[:address])}&key=#{Setting.first.amapkey}")
    response = Net::HTTP.get(uri)
    return_api(JSON.parse(response)["geocodes"][0]["adcode"])
  end
end
