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
    seller = Seller.create(
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
    data["deliverselect"].each do |f|
      delivermode = Delivermode.find_by_name(f)
      seller.delivermodes << delivermode
    end
    return_res('')
  end

  def update
    seller = Seller.find(params[:id])
    data = JSON.parse(params[:data])
    seller.update(
        name:data["name"],
        address: data["address"],
        status: data["statu"] == true ? 1 : 0,
        cover: data["cover"],
        summary: data["summary"],
        contact: data["contact"],
        contactphone: data["contactphone"],
        login: data["login"]
        )
    if data["password"].size > 0
      seller.update(
          password: data["password"],
          password_confirmation: data["password"])
    end
    seller.delivermodes.destroy_all
    data["deliverselect"].each do |f|
      delivermode = Delivermode.find_by_name(f)
      seller.delivermodes << delivermode
    end
    return_res('')
  end

  def show
    seller = Seller.find(params[:id])
    delivermodes = Delivermode.all
    deliverarr = []
    deliverselect = []
    delivermodes.each do |f|
      deliver_param = {
          id: f.id,
          name: f.name,
          keyword: f.keyword,
          isselect: seller.delivermodes.map(&:id).include?(f.id) ? 1 : 0
      }
      deliverarr.push deliver_param
      if seller.delivermodes.map(&:id).include?(f.id)
        deliverselect.push f.name
      end
    end
    param = {
        id: seller.id,
        name: seller.name,
        address: seller.address,
        statu: seller.status.to_i,
        cover: seller.cover,
        summary: seller.summary,
        contact: seller.contact,
        contactphone: seller.contactphone,
        login: seller.login,
        delivermode: deliverarr,
        deliverselect: deliverselect
    }
    return_res(param)
  end

  def destroy
    seller = Seller.find(params[:id])
    seller.destroy
    return_res('')
  end

  def get_delivermode
    delivermodes = Delivermode.all
    delivermodearr = []
    delivermodes.each do |f|
      delivermode_param = {
          id:f.id,
          name:f.name
      }
      delivermodearr.push delivermode_param
    end
    return_res(delivermodearr)
  end

  def ckeck_login_unipue
    seller = Seller.find_by_login(params[:login])
    status = 0
    status = 1 if seller
    return_res(status)
  end
end
