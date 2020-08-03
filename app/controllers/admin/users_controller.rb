class Admin::UsersController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      users = User.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      users = User.all
    end
    users = users.page(params[:page]).per(params[:per])
    usertarr = []
    users.each do |user|
      phone = ''
      phone = user.realname.phone if user.realname
      agent = ''
      examine = 0
      quarter = create_quarter
      if user.isagent == 1
        useragent = user.useragents.where('quarter_id = ?', quarter.id).first
        agent = useragent.agent.name
        examine = useragent.examine
      end
      address = ''
      if user.realname
        address = user.realname.province + user.realname.city + user.realname.district
      end
      user_param = {
          id:user.id,
          openid:user.openid,
          nickname:user.nickname,
          name:user.name,
          phone:phone,
          agent:agent,
          address:address,
          examine:examine,
          token:user.token
      }
      usertarr.push user_param
    end
    param = {
        data:usertarr,
        total:User.all.size
    }
    return_res(param)
  end

  def show
    user = User.find(params[:id])
    agent= ''
    if user.isagent == 1
      quarter = create_quarter
      useragent = user.useragents.where('quarter_id = ?', quarter.id).first
      agent = useragent.agent.name
      examine = useragent.examine
    end
    param = {
        id:user.id,
        openid:user.openid,
        token:user.token,
        headurl:user.headurl,
        nickname:user.nickname,
        name:user.name,
        token:user.token,
        agent:agent,
        examine:examine,
        balance:user.balance,
        income:user.income,
        deposit:user.deposit
    }
    return_res(param)
  end
end
