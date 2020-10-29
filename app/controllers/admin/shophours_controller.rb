class Admin::ShophoursController < ApplicationController
  def index
    seller = Seller.find(params[:seller_id])
    shophours = seller.shophours
    shophourarr = []
    shophours.each do |f|
      shophour_param = {
          id: f.id,
          begintime: f.begintime.strftime('%H:%M:%S'),
          endtime: f.endtime.strftime('%H:%M:%S')
      }
      shophourarr.push shophour_param
    end
    return_res(shophourarr)
  end

  def create
    seller = Seller.find(params[:seller_id])
    data = JSON.parse(params[:data])
    seller.shophours.create(begintime: data["starttime"], endtime: data["endtime"] + ":59")
    return_res("")
  end

  def update
    seller = Seller.find(params[:seller_id])
    data = JSON.parse(params[:data])
    seller.shophours.create(begintime: data["starttime"], endtime: data["endtime"] + ":59")
    return_res("")
  end

  def destroy
    shophour = Shophour.find(params[:id])
    shophour.destroy
    return_res("")
  end
end
