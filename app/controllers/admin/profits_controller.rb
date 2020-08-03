class Admin::ProfitsController < ApplicationController
  def index
    if params[:filterchk] && JSON.parse(params[:filterchk]).size > 0
      users = User.where('up_id is null or up_id = ?', 0)
    else
      users = User.all.order('created_at desc')
    end
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      users = users.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      users = users.order('created_at desc')
    end



    users = users.page(params[:page]).per(params[:per])

    userarr = []
    users.each do |f|
      name = f.openid.to_s
      name = f.nickname.to_s if f.nickname.to_s.size > 0
      name = f.name if f.name.to_s.size > 0
      phone = ''
      phone = f.realname.phone if f.realname
      agent = '无'
      quarter =  create_quarter
      useragent = f.useragents.where('quarter_id = ?',quarter.id).first
      if useragent
        agent = useragent.agent.name
      end
      user_param = {
          id: f.id,
          name: name,
          phone: phone,
          agent: agent,
          headurl: f.headurl.to_s,
          owersale: ActiveSupport::NumberHelper.number_to_currency(f.orders.where('paystatus = ?',1).sum('amount'),unit:'￥'),
          teamsale: ActiveSupport::NumberHelper.number_to_currency(get_teamsale(f.id, 0),unit:'￥'),
          task: ActiveSupport::NumberHelper.number_to_currency(f.usertasks.sum('amount'),unit:'￥'),
          stayincome: ActiveSupport::NumberHelper.number_to_currency(f.userincomes.where('status = ?', 0).sum('amount'),unit:'￥'),
          income: ActiveSupport::NumberHelper.number_to_currency(f.userincomes.where('status = ?', 1).sum('amount'),unit:'￥'),
          withdraw: ActiveSupport::NumberHelper.number_to_currency(f.withdrawals.sum('amount'),unit:'￥'),
          teamcount: get_teamcount(f.id, 0),
          teamagent: get_teamagent(f.id, 0)
      }
      userarr.push user_param
    end
    param = {
        data: userarr,
        total:users.total_count
    }
    return_res(param)
  end

  private
  def get_teamsale(userid, amount)
    user = User.find(userid)
    childrens = user.childrens
    childrens.each do |f|
      amount += get_teamsale(f.id, amount)
    end
    amount = user.orders.where('paystatus = ?', 1).sum('amount')
    amount
  end

  def get_teamcount(userid, count)
    user = User.find(userid)
    childrens = user.childrens
    childrens.each do |f|
      count += get_teamcount(f.id, count)
    end
    count += 1
    count
  end

  def get_teamagent(userid, count)
    user = User.find(userid)
    childrens = user.childrens
    childrens.each do |f|
      count += get_teamcount(f.id, count)
    end
    if user.isagent.to_i == 1
      count += 1
    end
    count
  end
end
