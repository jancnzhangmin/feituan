class Admin::BuyfullproductsController < ApplicationController
  def index
    buyfull = Buyfull.find(params[:buyfull_id])
    buyfullproducts = buyfull.buyfullproducts
    buyfullarr = []
    buyfullproducts.each do |f|
      buyfull_param = {
          product_id: f.product_id,
          product: f.product.name,
          number: f.buynumber
      }
      buyfullarr.push buyfull_param
    end
    return_res(buyfullarr)
  end

  def create
    buyfull = Buyfull.find(params[:buyfull_id])
    data = JSON.parse(params[:data])
    buyfull.buyfullproducts.destroy_all
    data.each do |f|
      buyfull.buyfullproducts.create(product_id:f["product_id"], buynumber:f["number"])
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
