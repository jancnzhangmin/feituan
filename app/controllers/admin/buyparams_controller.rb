class Admin::BuyparamsController < ApplicationController
  def index
    buyparams = Product.find(params[:product_id]).buyparams
    buyparamarr = []
    buyparams.each do |f|
      param = {
          id:f.id,
          name:f.name,
          buyparamcount:f.buyparamoptions.size
      }
      buyparamarr.push param
    end
    return_res(buyparamarr)
  end

  def create
    data = JSON.parse(params[:data])
    buyparam = Product.find(params[:product_id]).buyparams.new(name:data["name"])
    if buyparam.save
      return_res('')
    else
      return_res('', 10001, buyparam.errors.full_messages(&:msg).join(' '))
    end
  end

  def show
    buyparam = Buyparam.find(params[:id])
    return_res(buyparam)
  end

  def update
    data = JSON.parse(params[:data])
    buyparam = Buyparam.find(params[:id])
    if buyparam.update(name:data["name"])
      return_res('')
    else
      return_res('', 10001, buyparam.errors.full_messages(&:msg).join(' '))
    end
  end

  def destroy
    buyparam = Buyparamoption.find(params[:id])
    if buyparam.destroy
      return_res('')
    else
      return_res('', 10001, buyparam.errors.full_messages(&:msg).join(' '))
    end
  end

end
