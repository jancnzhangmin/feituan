class Admin::DelivermodesController < ApplicationController
  def index
    delivermodels = Delivermode.all
    delivermodearr = []
    delivermodels.each do |f|
      delivermode_param = {
          id: f.id,
          name: f.name,
          keyword: f.keyword,
          weighting: f.weighting,
          isdefault: f.isdefault
      }
      delivermodearr.push delivermode_param
    end
    return_res(delivermodearr)
  end

  def show
    delivermode = Delivermode.find(params[:id])
    param = {
        id: delivermode.id,
        name: delivermode.name,
        keyword: delivermode.keyword,
        weighting: delivermode.weighting,
        isdefault: delivermode.isdefault.to_i
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    isdefault = 0
    isdefault = 1 if data["isdefault"] == true
    if isdefault == 1
      delivermodes = Delivermode.all
      delivermodes.each do |f|
        f.isdefault = 0
        f.save
      end
    end
    Delivermode.create(name: data["name"], keyword:data["keyword"], isdefault:isdefault, weighting:data["weighting"])
    return_res('')
  end

  def update
    delivermode = Delivermode.find(params[:id])
    data = JSON.parse(params[:data])
    isdefault = 0
    isdefault = 1 if data["isdefault"] == true
    if isdefault == 1
      delivermodes = Delivermode.all
      delivermodes.each do |f|
        f.isdefault = 0
        f.save
      end
    else
      paydelivermode = Delivermode.find_by_keyword('pay')
      paydelivermode.isdefault = 1
      paydelivermode.save
    end
    delivermode.update(name: data["name"], keyword:data["keyword"], isdefault:isdefault, weighting:data["weighting"])
    return_res('')
  end

  def destroy
    delivermode = Delivermode.find(params[:id])
    if delivermode.isdefault == 1
      paydelivermode = Delivermode.find_by_keyword('pay')
      paydelivermode.isdefault = 1
      paydelivermode.save
    end
    delivermode.destroy
    return_res('')
  end
end
