class Api::ProductlistsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    productcla = Productcla.all
    productclaarr = []
    productarr = {}
    productids = []
    productcla.each do |f|
      param = {
          id: f.id,
          name: f.name
      }
      if f.products.where('onsale = ?', 1).size > 0
        productclaarr.push param
      end
      products = f.products.where('onsale = ?', 1)

      temarr = []
      products.each do |product|
        if !productids.include? product.id
          # if user && user.isagent == 1
          #   agentprice = Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, product.id).first.price if Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, product.id).size > 0
          # else
          #   agentprice = product.price
          # end
          agentprice = get_useragentprice(user,product.id)

          buyparam = ''
          buyparamoption = []
          buyparamtem = product.buyparams.first if product.buyparams.size > 0
          if buyparamtem
            buyparam = product.buyparams.first.name
            chec = true
            buyparamtem.buyparamoptions.each do |f|
              param = {
                  value: f.id,
                  buyparam_id: f.buyparam_id,
                  name: f.name,
                  buyparamoptionimg: f.buyparamoptionimg,
                  weighting: agentprice.to_f + f.weighting.to_f,
                  checked:chec,
                  buyparam_id: product.buyparams.first.id
              }
              chec = false
              buyparamoption.push param
            end
          end
          param = {
              id: product.id,
              productcla_id: product.productclas.ids,
              name: product.name,
              subname: product.subname,
              cover: product.cover.split('?')[0],
              agentprice: agentprice,
              price: product.price,
              activestatus: 0,
              activename: '',
              buyparam: buyparam,
              buyparamoption: buyparamoption
          }
          temarr.push param
          productids.push product.id
        end
      end
      if temarr.size > 0
        productarr[f.id] = temarr
      end
    end
    param = {
        productclas: productclaarr,
        productlist: productarr
    }
    return_api(param)


    # products = Product.where('onsale = ?',1)
    # productarr = []
    # user = User.find_by_token(params[:token])
    # products.each do |f|
    #   if user && user.isagent == 1
    #     agentprice = Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, f.id).first.price if Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, f.id).size > 0
    #   else
    #     agentprice = f.price
    #   end
    #   param = {
    #       id: f.id,
    #       productcla_id: f.productclas.ids,
    #       name: f.name,
    #       subname: f.subname,
    #       cover: f.cover.split('?')[0],
    #       agentprice: agentprice,
    #       price: f.price,
    #       activestatus: 0,
    #       activename: ''
    #   }
    #   productarr.push param
    # end
    # param = {
    #     productclas: productclaarr,
    #     products: productarr
    # }
    # return_api(param)
  end
end
