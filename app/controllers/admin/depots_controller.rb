class Admin::DepotsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      depots = Depot.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      depots = Depot.all.order('updated_at desc')
    end
    depots = depots.page(params[:page]).per(params[:per])
    depotarr = []
    depots.each do |f|
      buyparamoption = Buyparamoption.find_by(id:f.buyparamoption_id)
      if buyparamoption
        buyparamoption_name = buyparamoption.name
      else
        buyparamoption_name = ''
      end
      depot_param ={
          id: f.id,
          product: f.product.name,
          buyparamoption: buyparamoption_name,
          cost: ActiveSupport::NumberHelper.number_to_currency(f.cost,unit:''),
          number:f.number,
          total: ActiveSupport::NumberHelper.number_to_currency(f.total,unit:'')
      }
      depotarr.push depot_param
    end

    #indepots = Indepot.all.order('id desc')
    param = {
        data:depotarr,
        total:Depot.all.size,
        current_page_cost: ActiveSupport::NumberHelper.number_to_currency(depots.sum('total'), unit:'￥'),
        total_cost:ActiveSupport::NumberHelper.number_to_currency(Depot.all.sum('total'), unit:'￥')
    }
    return_res(param)
  end
end
