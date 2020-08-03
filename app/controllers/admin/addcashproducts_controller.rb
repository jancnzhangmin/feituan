class Admin::AddcashproductsController < ApplicationController
  def index
    addcash = Addcash.find(params[:addcash_id])
    addcashproducts = addcash.addcashproducts
    addcasharr = []
    addcashproducts.each do |f|
      addcash_param = {
          product_id: f.product_id,
          product: f.product.name,
          number: f.buynumber
      }
      addcasharr.push addcash_param
    end
    return_res(addcasharr)
  end

  def create
    addcash = Addcash.find(params[:addcash_id])
    data = JSON.parse(params[:data])
    addcash.addcashproducts.destroy_all
    data.each do |f|
      addcash.addcashproducts.create(product_id:f["product_id"], buynumber:f["number"])
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
