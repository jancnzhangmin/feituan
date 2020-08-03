class Admin::BuyfullgiveproductsController < ApplicationController
  def index
    buyfull = Buyfull.find(params[:buyfull_id])
    buyfullgiveproducts = buyfull.buyfullgiveproducts
    buyfullarr = []
    buyfullgiveproducts.each do |f|
      buyfull_param = {
          product_id: f.product_id,
          product: f.product.name,
          number: f.givenumber
      }
      buyfullarr.push buyfull_param
    end
    return_res(buyfullarr)
  end

  def create
    buyfull = Buyfull.find(params[:buyfull_id])
    data = JSON.parse(params[:data])
    buyfull.buyfullgiveproducts.destroy_all
    data.each do |f|
      buyfull.buyfullgiveproducts.create(product_id:f["product_id"], givenumber:f["number"])
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
