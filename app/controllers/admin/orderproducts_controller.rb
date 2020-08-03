class Admin::OrderproductsController < ApplicationController
  def index
    orderproducts = Orderproduct.page(params[:page]).per(params[:per])
    orderproductarr = []
    orderproducts.each do |orderproduct|
      orderproduct_param = {
          id:orderproduct.id,
          selfnumber:orderproduct.selfnumber,
          name:orderproduct.name,
          spec:orderproduct.spec
      }
      orderproductarr.push orderproduct_param
    end
    param = {
        data:orderproductarr,
        total:Orderproduct.all.size
    }
    return_res(param)
  end

  def show
    orderproduct = Orderproduct.find(params[:id])
    return_res(orderproduct)
  end

  def create
    data = JSON.parse(params[:data])
    Orderproduct.create(selfnumber: data["selfnumber"], name:data["name"], spec:data["spec"])
    return_res('')
  end

  def update
    orderproduct = Orderproduct.find(params[:id])
    data = JSON.parse(params[:data])
    orderproduct.update(selfnumber:data["selfnumber"], name:data["name"], spec:data["spec"])
    return_res('')
  end

  def destroy
    orderproduct = Orderproduct.find(params[:id])
    orderproduct.destroy
    return_res('')
  end
end
