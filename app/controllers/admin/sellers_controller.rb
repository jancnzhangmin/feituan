class Admin::SellersController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      sellers = Seller.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      sellers = Seller.all
    end
    sellers = sellers.page(params[:page]).per(params[:per])
    sellerarr = []
    sellers.each do |f|
      seller_param = {
          id: f.id,
          name: f.name,
          address: f.address,
          lng: f.lng,
          lat: f.lat,
          status: f.status,
          cover: f.cover,
          summary: f.summary
      }
      sellerarr.push seller_param
    end
    param = {
        data: sellerarr,
        total:sellers.total_count
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    Seller.create(
        name:data["name"],
        address: data["address"],
        status: data["statu"] == true ? 1 : 0,
        cover: data["cover"].split('?')[0],
        summary: data["summary"],
        contact: data["contact"],
        contactphone: data["contactphone"],
        login: data["login"],
        password: data["password"],
        password_confirmation: data["password"]
    )
    return_res('')
  end

  def update
    seller = Seller.find(params[:id])
    data = JSON.parse(params[:data])
    seller.update(
        name:data["name"],
        address: data["address"],
        status: data["statu"] == true ? 1 : 0,
        cover: data["cover"].split('?')[0],
        summary: data["summary"],
        contact: data["contact"],
        contactphone: data["contactphone"],
        login: data["login"],
        password: data["password"],
        password_confirmation: data["password"]
    )
    return_res('')
  end

  def show
    seller = Seller.find(params[:id])
    param = {
        id: seller.id,
        name: seller.name,
        address: seller.address,
        statu: seller.status.to_i,
        cover: seller.cover,
        summary: seller.summary,
        contact: seller.contact,
        contactphone: seller.contactphone,
        login: seller.login
    }
    return_res(param)
  end

  def destroy
    seller = Seller.find(params[:id])
    seller.destroy
    return_res('')
  end
end
