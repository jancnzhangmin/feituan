class Api::BuycarsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    buycars = user.buycars
    buyarr = []
    pricesum = 0
    buycars.each do |f|
      product = Product.find(f.product_id)
      buycarcondition = f.buycarcondition
      cover = product.cover.split('?')[0]
      cover = Buyparamoption.find(buycarcondition.buyoption_id).buyparamoptionimg.split('?')[0] if buycarcondition.buyoption_id != 0
      param = {
          id: f.id,
          number: f.number,
          amount: f.amount,
          producttype: f.producttype,
          product_id: f.product_id,
          name: product.name,
          cover: cover,
          buyparam_id: buycarcondition.buyparam_id,
          buyparam: buycarcondition.buyparam,
          buyoption_id: buycarcondition.buyoption_id,
          buyoption: buycarcondition.buyoption
      }
      pricesum += f.number * f.amount
      buyarr.push param
    end
    param = {
        buycar: buyarr,
        pricesum: pricesum
    }
    return_api(param)
  end

  def create
    user = User.find_by_token(params[:token])
    buycars = user.buycars
    oldvalue = buycars.select{|n|n.product_id == params[:buycar][:product_id].to_i}
    agentprice = Product.find(params[:buycar][:product_id]).price
    if user.isagent == 1
      #agentprice = Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, params[:buycar][:product_id]).first.price if Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, params[:buycar][:product_id]).size > 0
      agentprice = get_useragentprice(user,params[:buycar][:product_id])
    end
    if params[:buycar][:buyoption_id].to_i != 0
      agentprice += Buyparamoption.find(params[:buycar][:buyoption_id]).weighting
    end
    if oldvalue.size > 0 && oldvalue.first.buycarcondition.buyoption_id == params[:buycar][:buyoption_id].to_i
      oldvalue.first.number += params[:buycar][:number].to_f
      oldvalue.first.amount = agentprice
      oldvalue.first.save
    else
      buycar = user.buycars.create(product_id: params[:buycar][:product_id], number:params[:buycar][:number], amount:agentprice, producttype:0)
      buyparam = ''
      buyparam = Buyparam.find_by(id:params[:buycar][:buyparam_id]).name if Buyparam.find_by(id:params[:buycar][:buyparam_id])
      buyoption = ''
      buyoption = Buyparamoption.find_by(id:params[:buycar][:buyoption_id]).name if Buyparamoption.find_by(id:params[:buycar][:buyoption_id])
      buycar.create_buycarcondition(buyparam_id:params[:buycar][:buyparam_id], buyparam:buyparam, buyoption_id:params[:buycar][:buyoption_id], buyoption:buyoption)
    end
    return_api('')
  end

  def changenumber
    user = User.find_by_token(params[:token])
    buycars = user.buycars
    bc = JSON.parse(params[:buycar][2])
    buycar = nil
    buycars.each do |f|
      if bc[0] == f.product_id && f.buycarcondition.buyoption_id == bc[2]
        buycar = f
        break
      end
    end
    if params[:buycar][0] == 0
      buycar.destroy
    else
      buycar.number = params[:buycar][0]
      # agentprice = Product.find(buycar.product_id).price
      # if user.isagent == 1
      #   agentprice = Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, buycar.product_id) if Agentprice.where('agent_id = ? and product_id = ?', user.useragent.agent_id, buycar.product_id).size > 0
      #   agentprice = get_useragentprice(user,buycar.product_id)
      # end
      agentprice = get_useragentprice(user,buycar.product_id)
      if buycar.buycarcondition.buyoption_id != 0
        agentprice += Buyparamoption.find(buycar.buycarcondition.buyoption_id).weighting
      end
      buycar.amount = agentprice
      buycar.save
    end
    return_api('')
  end
end
