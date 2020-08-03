class Admin::LimitdiscountproductsController < ApplicationController
  def index
    limitdiscount = Limitdiscount.find(params[:limitdiscount_id])
    limitdiscountproducts = limitdiscount.limitdiscountproducts
    limitdiscountarr = []
    limitdiscountproducts.each do |f|
      param = {
          product_id: f.product_id,
          product: f.product.name,
          rate: f.rate,
          number: f.basenumber
      }
      limitdiscountarr.push param
    end
    return_res(limitdiscountarr)
  end

  def create
    limitdiscount = Limitdiscount.find(params[:limitdiscount_id])
    data = JSON.parse(params[:data])
    limitdiscount.limitdiscountproducts.destroy_all
    data.each do |f|
      limitdiscount.limitdiscountproducts.create(product_id:f["product_id"], basenumber:f["number"], rate:f["rate"])
    end
    return_res('')
  end

  def get_products
    products = Product.all
    productarr = []
    products.each do |f|
      product_param = {
          product_id: f.id,
          product: f.name
      }
      productarr.push product_param
    end
    return_res(productarr)
  end
end
