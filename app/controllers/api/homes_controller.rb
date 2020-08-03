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
    param = {
        productcla: productclaarr,
        productlist: productarr
    }
    return_api(param)
  end
end
