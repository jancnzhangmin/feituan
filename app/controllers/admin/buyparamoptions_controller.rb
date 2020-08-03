class Admin::BuyparamoptionsController < ApplicationController
  def index
    buyparamoptions = Product.find(params[:product_id]).buyparams.find(params[:buyparam_id]).buyparamoptions
    return_res(buyparamoptions)
  end

  def create
    data = JSON.parse(params[:data])
    buyparamoption = Product.find(params[:product_id]).buyparams.find(params[:buyparam_id]).buyparamoptions.new(name:data["name"], weighting:data["weighting"], weight:data["weight"], buyparamoptionimg:data["buyparamoptionimg"])
    if buyparamoption.save
      return_res('')
    else
      return_res('', 10001, buyparamoption.errors.full_messages(&:msg).join(' '))
    end
  end

  def show
    buyparamoption = Buyparamoption.find(params[:id])
    return_res(buyparamoption)
  end

  def update
    data = JSON.parse(params[:data])
    buyparamoption = Buyparamoption.find(params[:id])
    if buyparamoption.update(name:data["name"], weighting:data["weighting"], weight:data["weight"], buyparamoptionimg:data["buyparamoptionimg"])
      return_res('')
    else
      return_res('', 10001, buyparamoption.errors.full_messages(&:msg).join(' '))
    end
  end

end
