class Admin::AddcashgisController < ApplicationController
  def index
    addcash = Addcash.find(params[:addcash_id])
    addcashgis = addcash.addcashgis
    addcasharr = []
    addcashgis.each do |f|
      addcash_param = {
          product_id: f.product_id,
          product: f.product.name,
          price: f.price
      }
      addcasharr.push addcash_param
    end
    return_res(addcasharr)
  end

  def create
    addcash = Addcash.find(params[:addcash_id])
    data = JSON.parse(params[:data])
    addcash.addcashgis.destroy_all
    data.each do |f|
      addcash.addcashgis.create(product_id:f["product_id"], price:f["price"])
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
