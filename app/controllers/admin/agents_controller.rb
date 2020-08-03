class Admin::AgentsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      agents = Agent.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      agents = Agent.all.order('corder')
    end
    agents = agents.page(params[:page]).per(params[:per])
    agentarr = []
    agents.each do |f|
      param = {
          id: f.id,
          name: f.name,
          price: ActiveSupport::NumberHelper.number_to_currency(f.price, unit:'￥'),
          deposit: ActiveSupport::NumberHelper.number_to_currency(f.deposit, unit:'￥'),
          task: ActiveSupport::NumberHelper.number_to_currency(f.task, unit:'￥'),
          corder: f.corder,
          onfront: f.onfront
      }
      agentarr.push param
    end
    param = {
        data:agentarr,
        total:Agent.all.size
    }
    return_res(param)
  end

  def show
    agent = Agent.find(params[:id])
    param = {
        id: agent.id,
        name: agent.name,
        price: agent.price,
        deposit: agent.deposit,
        task: agent.task,
        onfront: agent.onfront.to_i
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    onfront = 0
    onfront = 1 if data["onfront"] == true
    agent = Agent.new(name:data["name"], price:data["price"], deposit:data["deposit"], task:data["task"], onfront:onfront)
    if agent.save
      return_res('', 10000,'新增记录成功')
    else
      return_res('', 10001, setting.errors)
    end
  end

  def update
    data = JSON.parse(params[:data])
    agent = Agent.find(params[:id])
    onfront = 0
    onfront = 1 if data["onfront"] == true
    agent.update(name:data["name"], price:data["price"], deposit:data["deposit"], task:data["task"], onfront:onfront)
    return_res('')
  end

  def destroy
    agent = Agent.find(params[:id])
    if agent.destroy
      return_res('')
    else
      return_res('',10001,productcla.errors.full_messages(&:msg).join(' '))
    end
  end

  def sort
    if params[:from_id] != params[:to_id]
      agent = Agent.find_by_corder(params[:from_id])
      if params[:from_id].to_i > params[:to_id].to_i
        agents = Agent.where('corder < ? and corder >= ?',params[:from_id].to_i, params[:to_id].to_i).order('corder asc')
        agentarr = agents.ids
        agents.each do |f|
          newid = agentarr.index(f.id)
          if newid < agentarr.size - 1
            f.corder = Agent.find(agentarr[newid + 1]).corder
          else
            f.corder = agent.corder
          end
          f.save
        end
      else
        agents = Agent.where('corder > ? and corder <= ?',params[:from_id].to_i, params[:to_id].to_i).order('corder desc')
        agentarr = agents.ids
        agents.each do |f|
          newid = agentarr.index(f.id)
          if newid <  agentarr.size - 1
            f.corder = Agent.find(agentarr[newid + 1]).corder
          else
            f.corder = agent.corder
          end
          f.save
        end
      end
      agent.corder = params[:to_id]
      agent.save
    end

    agents = Agent.all.order('corder asc')
    agentarr = []
    agents.each do |f|
      param = {
          id: f.id,
          name: f.name,
          price: ActiveSupport::NumberHelper.number_to_currency(f.price, unit:'￥'),
          deposit: ActiveSupport::NumberHelper.number_to_currency(f.deposit, unit:'￥'),
          task: ActiveSupport::NumberHelper.number_to_currency(f.task, unit:'￥'),
          corder: f.corder
      }
      agentarr.push param
    end
    return_res(agentarr)
  end

  def check_unique
    agent = Agent.find_by_name(params[:name])
    status = 0
    status = 1 if agent
    return_res(status)
  end
end
