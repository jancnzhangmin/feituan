class Admin::ProductclasController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      productclas = Productcla.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      productclas = Productcla.all
    end
    productclas = productclas.page(params[:page]).per(params[:per])
    productclaarr = []
    productclas.each do |productcla|
      productcla_param = {
          id:productcla.id,
          name:productcla.name,
          keyword:productcla.keyword,
          onhome: productcla.onhome,
          productcount:productcla.products.size
      }
      productclaarr.push productcla_param
    end
    param = {
        data:productclaarr,
        total:Productcla.all.size
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    productcla = Productcla.new(name:data["name"], keyword:data["keyword"])
    if productcla.save
      return_res('', 10000,'新增记录成功')
    else
      return_res('', 10001, setting.errors)
    end
  end

  def show
    productcla = Productcla.find(params[:id])
    if productcla
      return_res(productcla)
    else
      return_res('', 10001, '无效的记录值')
    end
  end

  def update
    data = JSON.parse(params[:data])
    productcla = Productcla.find(params[:id])
    productcla.name = data["name"]
    productcla.keyword = data["keyword"]
    if productcla.save
      return_res('', 10000,'记录更新成功')
    else
      return_res('', 10001, setting.errors)
    end
  end

  def destroy
    productcla = Productcla.find(params[:id])
    if productcla.destroy
    return_res('')
    else
      return_res('',10001,productcla.errors.full_messages(&:msg).join(' '))
    end
  end

  def ckeck_keyword_unipue
    productcla = Productcla.find_by_keyword(params[:keyword])
    status = 0
    status = 1 if productcla
    return_res(status)
  end

  def get_product_cla
    products = Product.all
    productcla = Productcla.find(params[:id])
    inproducts = productcla.products.ids
    productarr = []
    products.each do |product|
      product_param = {
          key:product.id,
          label:product.name
      }
      productarr.push product_param
    end
    param = {
            inproducts:inproducts,
            unproducts:productarr,
            cla_name:productcla.name,
            cla_keyword:productcla.keyword
    }
    return_res(param)
  end

  def change_cla
    productcla = Productcla.find(params[:id])
    from = params[:from].split(',')
    to = params[:to].split(',')
    if params[:direction] == 'right'
      from.each do |f|
        productcla.products << Product.find(f)
      end
    else
      to.each do |f|
        productcla.products.destroy(Product.find(f))
      end
    end
    return_res('')
  end

end
