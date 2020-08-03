class Admin::ProductsharesController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    productshares = product.productshares
    return_api(productshares)
  end

  def create
    product = Product.find(params[:product_id])
    product.productshares.create(productshare:params[:productshare].split('?')[0])
    return_res('')
  end

  def update
    productshare = Productshare.find(params[:id])
    productshare.update(productshare:params[:productshare].split('?')[0], content:'')
    return_res('')
  end

  def show
    productshare = Productshare.find(params[:id])
    return_res(productshare)
  end

  def destroy
    productshare = Productshare.find(params[:id])
    productshare.destroy
    return_res('')
  end

  def getshare
    qrcode = Setting.first.qrcode
    productshare = Productshare.find(params[:productshare_id])
    param = {
        qrcode:qrcode,
        productshare:productshare
    }
    return_res(param)
  end

  def updateshare
    productshare = Productshare.find(params[:id])
    productshare.update(content:params[:content])
    return_res('')
  end

end
