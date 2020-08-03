class Api::ProductsharesController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    productshares = product.productshares
    return_api(productshares)
  end
end
