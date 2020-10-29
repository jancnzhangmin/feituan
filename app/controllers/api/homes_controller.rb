class Api::HomesController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    productclas = Productcla.where('onhome = ?',1)
    products = Product.where('onsale = ?',1)
    productclaarr = []
    productclas.each do |f|
      param = {
          id: f.id,
          name: f.name,
          keyword: f.keyword
      }
      productclaarr.push param
    end
    productarr = []
    products.each do |f|
      if user && user.isagent == 1
        #agentprice = Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, f.id).first.price if Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, f.id).size > 0
        agentprice = get_useragentprice(user, f.id)
      else
        agentprice = f.price
      end
      param = {
          id: f.id,
          name: f.name,
          subname: f.subname,
          cover: f.cover.split('?')[0],
          agentprice: agentprice,
          price: f.price,
          activestatus: 0,
          activename: ''
      }
      productarr.push param
    end
    todaydeals = Todaydeal.where('begintime < ? and endtime > ?', Time.now, Time.now)
    productidsarr = []
    todaydeals.each do |f|
      productidsarr += f.products.ids
    end
    productidsarr.uniq!

    todayarr = []
    productidsarr.each do |f|
      product = Product.find(f)
      product_param = {
          id: product.id,
          name: product.name,
          img: product.cover,
          price: product.price
      }
      todayarr.push product_param
    end

    param = {
        productcla: productclaarr,
        productlist: productarr,
        today: todayarr
    }
    return_api(param)
  end

  def getrecommendseller
    sellers = Seller.all
    sellarr = []
    sellers.each do |seller|
      seller_param = {
          id: seller.id,

      }
    end
  end

  def searchproduct
    products = Product.where('onsale = ? and ( name like ? or pinyin like ? or fullpinyin like ?)',1,"%#{params[:keyword]}%","%#{params[:keyword]}%","%#{params[:keyword]}%")
    productarr = []
    products.each do |f|
      param = {
          id: f.id,
          name: f.name,
          subname: f.subname,
          cover: f.cover.split('?')[0],
          agentprice: f.price,
          price: f.price,
          activestatus: 0,
          activename: ''
      }
      productarr.push param
    end
    return_api(productarr)
  end

end
