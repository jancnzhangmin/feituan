class Admin::ProductbannersController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    productbanners = product.productbanners.order('corder asc')
    productbannerarr = []
    productbanners.each do |f|
      param = {
          id:f.corder,
          productbanner:f.productbanner
      }
      productbannerarr.push param
    end
    return_res(productbannerarr)
  end

  def create
    data = JSON.parse(params[:data])
    productbanner = Product.find(params[:product_id]).productbanners.new(productbanner:data["productbanner"])
    if productbanner.save
      param = {
          id:productbanner.corder,
          productbanner:productbanner.productbanner
      }
      return_res(param)
    else
      return_res('', 10001, productbanner.errors.full_messages(&:msg).join(' '))
    end
  end

  def destroy
    productbanner = Productbanner.find_by_corder(params[:id])
    productbanner.destroy
    return_res('')
  end

  def sort
    if params[:from_id] != params[:to_id]
      productbanner = Productbanner.find_by_corder(params[:from_id])
      if params[:from_id].to_i > params[:to_id].to_i
        productbanners = Product.find(params[:product_id]).productbanners.where('corder < ? and corder >= ?',params[:from_id].to_i, params[:to_id].to_i).order('corder asc')
        productbannerarr = productbanners.ids
        productbanners.each do |f|
          newid = productbannerarr.index(f.id)
          if newid < productbannerarr.size - 1
            f.corder = Productbanner.find(productbannerarr[newid + 1]).corder
          else
            f.corder = productbanner.corder
          end
          f.save
        end
      else
        productbanners = Product.find(params[:product_id]).productbanners.where('corder > ? and corder <= ?',params[:from_id].to_i, params[:to_id].to_i).order('corder desc')
        productbannerarr = productbanners.ids
        productbanners.each do |f|
          newid = productbannerarr.index(f.id)
          if newid <  productbannerarr.size - 1
            f.corder = Productbanner.find(productbannerarr[newid + 1]).corder
          else
            f.corder = productbanner.corder
          end
          f.save
        end
      end
      productbanner.corder = params[:to_id]
      productbanner.save
    end

    product = Product.find(params[:product_id])
    productbanners = product.productbanners.order('corder asc')
    productbannerarr = []
    productbanners.each do |f|
      param = {
          id:f.corder,
          productbanner:f.productbanner
      }
      productbannerarr.push param
    end
    return_res(productbannerarr)
  end
end
