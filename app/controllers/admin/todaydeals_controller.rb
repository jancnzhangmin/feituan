class Admin::TodaydealsController < ApplicationController
  def index
    todaydeals = Todaydeal.order('id desc')
    todaydeals = todaydeals.page(params[:page]).per(params[:per])
    todaydealarr = []
    todaydeals.each do |f|
      todaydeal_param = {
          id: f.id,
          begintime: f.begintime.strftime('%Y-%m-%d %H:%M:%S'),
          endtime: f.endtime.strftime('%Y-%m-%d %H:%M:%S'),
          productcount: f.products.size
      }
      todaydealarr.push todaydeal_param
    end
    param = {
        data: todaydealarr,
        total: todaydeals.size
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    Todaydeal.create(begintime: DateTime.parse(data[0]).beginning_of_day, endtime: DateTime.parse(data[1]).end_of_day)
    return_res('')
  end

  def update
    todaydeal = Todaydeal.find(params[:id])
    data = JSON.parse(params[:data])
    todaydeal.update(begintime: DateTime.parse(data[0]).beginning_of_day, endtime: DateTime.parse(data[1]).end_of_day)
    return_res('')
  end

  def show
    todaydeal = Todaydeal.find(params[:id])
    todaydeal_param = [
        todaydeal.begintime,
        todaydeal.endtime
    ]
    return_res(todaydeal_param)
  end

  def get_product
    todaydeal = Todaydeal.find(params[:id])
    products = todaydeal.products
    return_res(products.ids)
  end

  def set_product
    todaydeal = Todaydeal.find(params[:id])
    todaydeal.products.destroy_all
    data = JSON.parse(params[:data])
    data.each do |f|
      product = Product.find(f)
      todaydeal.products << product
    end
    return_res('')
  end

  def get_product_list
    products = Product.where('onsale = 1')
    productarr = []
    products.each do |f|
      product_param = {
          key: f.id,
          label: f.name
      }
      productarr.push product_param
    end
    return_res(productarr)
  end

  def destroy
    todaydeal = Todaydeal.find(params[:id])
    todaydeal.destroy
    return_res('')
  end
end
