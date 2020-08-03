class Admin::IndepotsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      indepots = Indepot.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      indepots = Indepot.all.order('ordernumber desc')
    end
    indepots = indepots.page(params[:page]).per(params[:per])
    indepotarr = []
    indepots.each do |f|
      indepot_param ={
          id: f.id,
          ordernumber: f.ordernumber,
          status: f.status,
          handle: f.handle,
          reviewer: f.reviewer,
          cost: f.cost,
          created_at: f.created_at.strftime('%Y-%m-%d %H:%M:%S')
      }
      indepotarr.push indepot_param
    end

    #indepots = Indepot.all.order('id desc')
    param = {
        data:indepotarr,
        total:Indepot.all.size
    }
    return_res(param)
  end

  def get_products
    products = Product.all
    buyparamoptions = Buyparamoption.all
    productarr = []
    products.each do |f|
      product_param = {
          product_id: f.id,
          product: f.name
      }
      productarr.push product_param
    end
    buyparamoptionarr = []
    buyparamoptions.each do |f|
      buyparamoption_param = {
          buyparamoption_id: f.id,
          buyparamoption: f.name,
          product_id: f.buyparam.product.id
      }
      buyparamoptionarr.push buyparamoption_param
    end
    param = {
        products: productarr,
        buyparamoptions: buyparamoptionarr
    }
    return_res(param)
  end

  def create
    indepot_param = JSON.parse(params[:indepot])
    indepot = Indepot.new(ordernumber:Time.now.strftime('%Y%m%d%H%M%S'), status:indepot_param["statu"], handle:indepot_param["handle"], reviewer:indepot_param["reviewer"], cost:0)
    indepot.save
    indepotdetail_param = JSON.parse(params[:indepotdetail])
    need = []
    indepotdetail_param.each do |f|
      #indepot.indepotdetails.create(product_id:f["product_id"], buyparamoption_id:f["isselect"], number:f["number"], cost:f["cost"])
      need << indepot.indepotdetails.new(product_id:f["product_id"], buyparamoption_id:f["isselect"], number:f["number"], cost:f["cost"])
    end
    indepot.indepotdetails << need
    return_res('')
  end

  def update
    indepot = Indepot.find(params[:id])
    indepot.indepotdetails.destroy_all
    indepot_param = JSON.parse(params[:indepot])
    indepot.update(status:indepot_param["statu"], handle:indepot_param["handle"], reviewer:indepot_param["reviewer"])
    indepotdetail_param = JSON.parse(params[:indepotdetail])
    need = []
    indepotdetail_param.each do |f|
      #indepot.indepotdetails.create(product_id:f["product_id"], buyparamoption_id:f["isselect"], number:f["number"], cost:f["cost"])
      need << indepot.indepotdetails.new(product_id:f["product_id"], buyparamoption_id:f["isselect"], number:f["number"], cost:f["cost"])
    end
    indepot.indepotdetails << need
    return_res('')
  end

  def show
    indepot = Indepot.find(params[:id])
    indepotdetails = indepot.indepotdetails
    param = {
        indepot: indepot,
        indepotdetails: indepotdetails
    }
    return_res(param)
  end

  def reviewer
    indepot = Indepot.find(params[:id])
    indepotdetails = indepot.indepotdetails
    if indepot.status == 0 || indepot.status == -1
      indepotdetails.each do |f|
        depot = Depot.where('product_id = ? and buyparamoption_id = ?', f.product_id, f.buyparamoption_id)
        oldcost = 0
        oldnumber = 0
        oldcost = depot[0].cost if depot.size > 0
        oldnumber = depot[0].number if depot.size > 0
        cost = (oldcost * oldnumber + f.cost * f.number) / (oldnumber + f.number)
        cost = f.cost if (oldnumber.to_f + f.number.to_f) == 0
        if depot.size > 0
          depot[0].cost = cost
          depot[0].number = oldnumber + f.number
          depot[0].save
        else
          Depot.create(product_id:f.product_id, buyparamoption_id:f.buyparamoption_id, cost:cost, number:oldnumber + f.number)
        end
      end
      indepot.status = 1
      indepot.save
    else
      indepotdetails.each do |f|
        depot = Depot.where('product_id = ? and buyparamoption_id = ?', f.product_id, f.buyparamoption_id)
        cost = depot[0].cost * depot[0].number - f.cost * f.number
        if depot[0].number != f.number
          cost = cost / (depot[0].number - f.number)
        else
          cost = 0
        end
        depot[0].cost = cost
        depot[0].number = depot[0].number - f.number
        depot[0].save
      end
      indepot.status = -1
      indepot.save
    end
    return_res('')
  end

  def destroy
    indepot = Indepot.find(params[:id])
    indepot.destroy
    return_res('')
  end
end
