class Admin::ShowparamsController < ApplicationController

  def index
    showparams = Product.find(params[:product_id]).showparams
    return_res(showparams)
  end

  def create
    data = JSON.parse(params[:data])
    product = Product.find(params[:product_id])
    product.showparams.destroy_all
    data.each do |f|
      if f["name"] != ""
        product.showparams.create(name:f["name"], param:f["param"])
      end
    end
    return_res('')
  end
end
