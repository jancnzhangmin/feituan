class Api::ProductclasController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    productcla = Productcla.find_by_keyword(params[:type])
    products = productcla.products.where('onsale = ?',1)
    productarr = []
    products.each do |f|
      if user && user.isagent == 1
        agentprice = Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, f.id).first.price if Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, f.id).size > 0
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
    return_api(productarr)
  end
end
