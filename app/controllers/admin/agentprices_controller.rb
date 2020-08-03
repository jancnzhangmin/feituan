class Admin::AgentpricesController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    agents = Agent.all
    agents.each do |f|
      if f.agentprices.where('product_id = ?', product.id).size == 0
        product.agentprices.create(agent_id:f.id, price:product.price)
      end
    end
    agentpricearr = []
    product.agentprices.each do |f|
      param = {
          id: f.id,
          label: f.agent.name,
          price: f.price
      }
      agentpricearr.push param
    end
    return_res(agentpricearr)
  end

  def create
    data = JSON.parse(params[:data])
    data.each do |f|
      agentprice = Agentprice.find(f["id"])
      agentprice.update(price:f["price"])
    end
    return_res('')
  end
end
