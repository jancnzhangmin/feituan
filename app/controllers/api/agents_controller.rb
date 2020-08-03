class Api::AgentsController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    if user.isagent == 1
      quarter = create_quarter
      useragent = user.useragents.where('quarter_id = ?', quarter.id).first
    end
    corder = 0
    corder = Agent.find(useragent.agent_id).corder if useragent
    agents = Agent.where('onfront = ? and corder > ?',1, corder).order('corder')
    agentarr = []
    chk = true
    agents.each do |f|
      param = {
          id: f.id,
          checked: chk,
          name: f.name,
          price: f.price,
          deposit: f.deposit,
          task: f.task
      }
      agentarr.push param
      chk = false
    end
    return_api(agentarr)
  end

  def create
    user = User.find_by_token(params[:token])
    quarter = create_quarter
    agent = Agent.find(params[:agentid])
    useragent = user.useragents.where('quarter_id = ?', quarter.id)
    orderamount = user.orders.where('paytime between ? and ?',quarter.begintime, quarter.endtime).sum('amount')
    if useragent.size == 0
      useragent = user.useragents.create(agent_id: params[:agentid], quarter_id: quarter.id, name:quarter.name, examine:0)
    else
      useragent = useragent.first
      useragent.update(agent_id: params[:agentid], examine:0)
    end
    user.charges.create(charge:agent.price - orderamount)
    user.deposit = agent.deposit
    user.isagent = 1
    user.save
    return_api('')
  end
end
