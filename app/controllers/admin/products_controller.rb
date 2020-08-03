class Admin::ProductsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      products = Product.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      products = Product.all
    end
    products = products.page(params[:page]).per(params[:per])
    productarr = []
    products.each do |product|
      product_param = {
          id:product.id,
          name:product.name,
          subname:product.subname,
          barcode:product.barcode,
          weight:product.weight,
          content:product.content,
          onsale:product.onsale,
          presale:product.presale,
          price:product.price,
          pinyin:product.pinyin,
          fullpinyin:product.fullpinyin,
          trial:product.trial,
          cover:product.cover,
          cla:product.productclas.map{|n|n.name},
          showparamscount:product.showparams.size,
          buyparamscount:product.buyparams.size,
          bannercount: product.productbanners.size,
          sharecount: product.productshares.size
      }
      productarr.push product_param
    end
    param = {
        data:productarr,
        total:Product.all.size
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    onsale = 0
    onsale = 1 if data["onsale"] == true
    presale = 0
    presale = 1 if data["presale"] == true
    trial = 0
    trial = 1 if data["trial"] == true
    product = Product.new(name:data["name"],
                          subname:data["subname"],
                          barcode:data["barcode"],
                          weight:data["weight"],
                          onsale:onsale,
                          presale:presale,
                          cover:data["cover"],
                          price:data["price"],
                          trial:trial,
                          content:data["content"]
                          )
    if product.save
      return_res('')
    else
      return_res('', 10001, product.errors)
    end
  end

  def update
    data = JSON.parse(params[:data])
    product = Product.find(params[:id])
    onsale = 0
    onsale = 1 if data["onsale"] == true
    presale = 0
    presale = 1 if data["presale"] == true
    trial = 0
    trial = 1 if data["trial"] == true
    if product.update(name:data["name"],
                          subname:data["subname"],
                          barcode:data["barcode"],
                          weight:data["weight"],
                          onsale:onsale,
                          presale:presale,
                          cover:data["cover"],
                          price:data["price"],
                          trial:trial,
                          content:data["content"]
    )
      return_res('')
    else
      return_res('', 10001, product.errors.full_messages(&:msg).join(' '))
    end
  end

  def show
    product = Product.find(params[:id])
    if product
      return_res(product)
    else
      return_res('', 10001, '无效的记录值')
    end
  end

  def destroy
    product = Product.find(params[:id])
    if product.destroy
      return_res('')
    else
      return_res('',10001,product.errors.full_messages(&:msg).join(' '))
    end
  end

end
