class Api::UsersController < ApplicationController
  def index
    user = User.find_by_token(params[:token])
    quarter = create_quarter
    orderamount = user.orders.where('paytime between ? and ?',quarter.begintime, quarter.endtime).sum('amount')
    agent = ''
    if user.isagent == 1
      agent = user.useragents.where('quarter_id = ?',quarter.id).first.agent.name
    end
    param = {
        id: user.id,
        openid: user.openid.to_s,
        unionid: user.unionid.to_s,
        token: user.token.to_s,
        nickname: user.nickname.to_s,
        name: user.name.to_s,
        aliasname: user.aliasname.to_s,
        headurl: user.headurl.to_s,
        realnamestatus: user.realnamestatus.to_i,
        isagent: user.isagent.to_i,
        agent: agent,
        deposit: user.deposit.to_f,
        balance: user.balance.to_f,
        income: user.income.to_f,
        stayincome: user.userincomes.where('status = ?', 0).sum('amount').round(2),
        monthincome: user.userincomes.where('created_at between ? and ? and status = ?', Time.now.beginning_of_month, Time.now.end_of_day, 1).sum('amount').round(2),
        orderamount: orderamount,
        paycount: user.orders.where('paystatus = ? and deliverstatus = ?',0, 0).size,
        delivercount: user.orders.where('paystatus = ? and deliverstatus = ?', 1, 0).size,
        receivecount: user.orders.where('deliverstatus = ? and receivestatus = ?', 1, 0).size,
        evaluatecount: user.orders.where('receivestatus = ? and evaluatestatus = ?',1, 0).size
    }
    return_api(JSON.parse(param.to_json))
  end

  def charge
    user = User.find_by_token(params[:token])
    user.charges.create(charge:params[:balance],summary:'冲值')
    return_api('')
  end

  def getbalancedetail
    user = User.find_by_token(params[:token])
    charges = user.charges.order('id desc').page(params[:page]).per(10)
    final = 0
    final = 1 if charges.last_page? || charges.out_of_range?
    chargearr = []
    charges.each do |f|
      way = 0
      way = 1 if f.charge > 0
      charge_param = {
          id: f.id,
          charge: ActiveSupport::NumberHelper.number_to_currency(f.charge,unit:'￥'),
          ordernumber: f.ordernumber.to_s,
          summary: f.summary.to_s,
          created_at: f.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          way: way
      }
      chargearr.push charge_param
    end
    param = {
        charges:chargearr,
        final:final
    }
    return_api(param)
  end

  def getstayincome
    user = User.find_by_token(params[:token])
    userincomes = user.userincomes.where('status = ?', 0).page(params[:page]).per(10)
    final = 0
    final = 1 if userincomes.last_page? || userincomes.out_of_range?
    userincomearr = []
    userincomes.each do |f|
      userincome_param = {
          id: f.id,
          amount: ActiveSupport::NumberHelper.number_to_currency(f.amount,unit:'￥'),
          ordernumber: f.order.ordernumber.to_s,
          summary: '代理差价',
          created_at: f.created_at.strftime('%Y-%m-%d %H:%M:%S'),
      }
      userincomearr.push userincome_param
    end
    param = {
        userincomes:userincomearr,
        final:final
    }
    return_api(param)
  end

  def financering
    user = User.find_by_token(params[:token])
    cyclename = ''
    if params[:cycle] == 'week'
      begintime = Time.now.beginning_of_day - 6.day
      endtime = Time.now.end_of_day
      cyclename = '7天'
    elsif params[:cycle] == 'month'
      begintime = Time.now.beginning_of_month
      endtime = Time.now.end_of_month
      cyclename = '本月'
    elsif params[:cycle] == 'quarter'
      begintime = Time.now.beginning_of_quarter
      endtime = Time.now.end_of_quarter
      cyclename = '季度'
    elsif params[:cycle] == 'year'
      begintime = Time.now.beginning_of_year
      endtime = Time.now.end_of_year
      cyclename = '今年'
    elsif params[:cycle] == 'custom'
      begintime = DateTime.parse(params[:startvalue])
      endtime = Time.now.end_of_day
      endtime = DateTime.parse(params[:endvalue]).end_of_day if params[:endvalue].to_s.size > 0
    end
    usersales = user.usersales.where('created_at between ? and ?', begintime, endtime).sum('amount').round(2)
    usersalescount = user.usersales.where('created_at between ? and ?', begintime, endtime).size
    usertasks = user.usertasks.where('created_at between ? and ?', begintime, endtime).sum('amount').round(2)
    usertaskscount = user.usertasks.where('created_at between ? and ?', begintime, endtime).size
    stayincomes = user.userincomes.where('created_at between ? and ? and status = ?', begintime, endtime, 0).sum('amount').round(2)
    stayincomescount = user.userincomes.where('created_at between ? and ? and status = ?', begintime, endtime, 0).size
    userincomes = user.userincomes.where('created_at between ? and ? and status = ?', begintime, endtime, 1).sum('amount').round(2)
    userincomescount = user.userincomes.where('created_at between ? and ? and status = ?', begintime, endtime, 1).size
    ordercount = cal_ordercount(user.id, begintime, endtime, 0)
    series = []
    series.push ({name: '销售', data: usersales})
    series.push ({name: '任务', data: usertasks})
    series.push ({name: '待收', data: stayincomes})
    series.push ({name: '收益', data: userincomes})

    label_param = {
        cyclename: cyclename,
        usersales: ActiveSupport::NumberHelper.number_to_currency(usersales, unit:'￥'),
        usersalescount: usersalescount,
        usertasks: ActiveSupport::NumberHelper.number_to_currency(usertasks, unit:'￥'),
        usertaskscount: usertaskscount,
        stayincomes: ActiveSupport::NumberHelper.number_to_currency(stayincomes, unit:'￥'),
        stayincomescount: stayincomescount,
        userincomes: ActiveSupport::NumberHelper.number_to_currency(userincomes, unit:'￥'),
        userincomescount: userincomescount,
        ordercount: ordercount
    }
    param = {
        series: series,
        label: label_param
    }
    return_api(param)
  end

  def financestack
    user = User.find_by_token(params[:token])
    if params[:cycle] == 'week'
      begintime = Time.now.beginning_of_day - 6.day
      endtime = Time.now.end_of_day
      section = endtime.day - begintime.day
      categories = []
      usersalesarr = []
      userrealsalesarr = []
      (section + 1).times do |i|
        categories.push (begintime + i.day).day.to_s
        beginday = begintime + i.day
        endday = (begintime + i.day).end_of_day
        usersales = user.usersales.where('created_at between ? and ?', beginday, endday).sum('amount')
        usersalesarr.push usersales
        userrealsales = user.userrealsales.where('created_at between ? and ?', beginday, endday).sum('amount')
        userrealsalesarr.push userrealsales
      end
      usersalessum = user.usersales.where('created_at between ? and ?', begintime, endtime).sum('amount')
      usersalescount = user.usersales.where('created_at between ? and ?', begintime, endtime).size
      userrealsalessum = user.userrealsales.where('created_at between ? and ?', begintime, endtime).sum('amount')
      userrealsalescount = user.userrealsales.where('created_at between ? and ?', begintime, endtime).size
    elsif params[:cycle] == 'month'
      begintime = Time.now.beginning_of_month
      endtime = Time.now.end_of_day
      section = endtime.day - begintime.day
      categories = []
      usersalesarr = []
      userrealsalesarr = []
      (section + 1).times do |i|
        categories.push (begintime + i.day).day
        beginday = begintime + i.day
        endday = (begintime + i.day).end_of_day
        usersales = user.usersales.where('created_at between ? and ?', beginday, endday).sum('amount')
        usersalesarr.push usersales
        userrealsales = user.userrealsales.where('created_at between ? and ?', beginday, endday).sum('amount')
        userrealsalesarr.push userrealsales
      end
      usersalessum = user.usersales.where('created_at between ? and ?', begintime, endtime).sum('amount')
      usersalescount = user.usersales.where('created_at between ? and ?', begintime, endtime).size
      userrealsalessum = user.userrealsales.where('created_at between ? and ?', begintime, endtime).sum('amount')
      userrealsalescount = user.userrealsales.where('created_at between ? and ?', begintime, endtime).size
    elsif params[:cycle] == 'quarter'
      begintime = Time.now.beginning_of_quarter
      endtime = Time.now.end_of_quarter
      section = ((endtime - begintime) / 60 / 60 / 24).to_i
      categories = []
      usersalesarr = []
      userrealsalesarr = []
      (section + 1).times do |i|
        categories.push ((begintime + i.day).month.to_s + '-' + (begintime + i.day).day.to_s)
        beginday = begintime + i.day
        endday = (begintime + i.day).end_of_day
        usersales = user.usersales.where('created_at between ? and ?', beginday, endday).sum('amount')
        usersalesarr.push usersales
        userrealsales = user.userrealsales.where('created_at between ? and ?', beginday, endday).sum('amount')
        userrealsalesarr.push userrealsales
      end
      usersalessum = user.usersales.where('created_at between ? and ?', begintime, endtime).sum('amount')
      usersalescount = user.usersales.where('created_at between ? and ?', begintime, endtime).size
      userrealsalessum = user.userrealsales.where('created_at between ? and ?', begintime, endtime).sum('amount')
      userrealsalescount = user.userrealsales.where('created_at between ? and ?', begintime, endtime).size
    elsif  params[:cycle] == 'year'
      begintime = Time.now.beginning_of_year
      endtime = Time.now.end_of_year
      section = endtime.month - begintime.month
      categories = []
      usersalesarr = []
      userrealsalesarr = []
      (section + 1).times do |i|
        categories.push ((begintime + i.month).month.to_s + '月')
        beginday = begintime + i.month
        endday = (begintime + i.month).end_of_month
        usersales = user.usersales.where('created_at between ? and ?', beginday, endday).sum('amount')
        usersalesarr.push usersales
        userrealsales = user.userrealsales.where('created_at between ? and ?', beginday, endday).sum('amount')
        userrealsalesarr.push userrealsales
      end
      usersalessum = user.usersales.where('created_at between ? and ?', begintime, endtime).sum('amount')
      usersalescount = user.usersales.where('created_at between ? and ?', begintime, endtime).size
      userrealsalessum = user.userrealsales.where('created_at between ? and ?', begintime, endtime).sum('amount')
      userrealsalescount = user.userrealsales.where('created_at between ? and ?', begintime, endtime).size
    elsif params[:cycle] == 'custom'
      begintime = DateTime.parse(params[:startvalue])
      endtime = Time.now.end_of_day
      endtime = DateTime.parse(params[:endvalue]) if params[:endvalue].to_s.size > 0
      section = (endtime - begintime).to_i
      categories = []
      usersalesarr = []
      userrealsalesarr = []
      (section + 1).times do |i|
        categories.push ((begintime + i.day).month.to_s + '-' + (begintime + i.day).day.to_s)
        beginday = begintime + i.day
        endday = (begintime + i.day).end_of_day
        usersales = user.usersales.where('created_at between ? and ?', beginday, endday).sum('amount')
        usersalesarr.push usersales
        userrealsales = user.userrealsales.where('created_at between ? and ?', beginday, endday).sum('amount')
        userrealsalesarr.push userrealsales
      end
      usersalessum = user.usersales.where('created_at between ? and ?', begintime, endtime).sum('amount')
      usersalescount = user.usersales.where('created_at between ? and ?', begintime, endtime).size
      userrealsalessum = user.userrealsales.where('created_at between ? and ?', begintime, endtime).sum('amount')
      userrealsalescount = user.userrealsales.where('created_at between ? and ?', begintime, endtime).size
    end
    param = {
        categories: categories,
        usersales: usersalesarr,
        userrealsales: userrealsalesarr,
        usersalessum: ActiveSupport::NumberHelper.number_to_currency(usersalessum, unit:'￥'),
        usersalescount: usersalescount,
        userrealsalessum: ActiveSupport::NumberHelper.number_to_currency(userrealsalessum, unit:'￥'),
        userrealsalescount: userrealsalescount
    }
    return_api(param)
  end

  def financeline
    user = User.find_by_token(params[:token])
    categories = []
    userincomearr = []
    userstayincomearr = []
    if params[:cycle] == 'month'
      begintime = Time.now.beginning_of_month
      endtime = Time.now.end_of_day
      section = ((endtime - begintime) / 60 / 60 / 24).to_i
      (section + 1).times do |i|
        categories.push (begintime + i.day).day
        beginday = begintime + i.day
        endday = (begintime + i.day).end_of_day
        userincomearr.push user.userincomes.where('created_at between ? and ? and status = ?', beginday, endday, 1).sum('amount')
        userstayincomearr.push user.userincomes.where('created_at between ? and ? and status = ?', beginday, endday, 0).sum('amount')
      end
    elsif params[:cycle] == 'quarter'
      begintime = Time.now.beginning_of_quarter
      endtime = Time.now.end_of_quarter
      section = ((endtime - begintime) / 60 / 60 / 24).to_i
      (section + 1).times do |i|
        categories.push (begintime + i.day).month.to_s + '-' + (begintime + i.day).day.to_s
        beginday = begintime + i.day
        endday = (begintime + i.day).end_of_day
        userincomearr.push user.userincomes.where('created_at between ? and ? and status = ?', beginday, endday, 1).sum('amount')
        userstayincomearr.push user.userincomes.where('created_at between ? and ? and status = ?', beginday, endday, 0).sum('amount')
      end
    elsif params[:cycle] == 'year'
      begintime = Time.now.beginning_of_year
      endtime = Time.now.end_of_year
      section = endtime.month - begintime.month
      (section + 1).times do |i|
        categories.push begintime.month.to_s + '月'
        beginday = begintime + i.month
        endday = (begintime + i.month).end_of_month
        userincomearr.push user.userincomes.where('created_at between ? and ? and status = ?', beginday, endday, 1).sum('amount')
        userstayincomearr.push user.userincomes.where('created_at between ? and ? and status = ?', beginday, endday, 0).sum('amount')
      end
    elsif params[:cycle] == 'custom'
      begintime = Time.now.beginning_of_year
      begintime = DateTime.parse(params[:startvalue]) if params[:startvalue].to_s.size > 0
      endtime = Time.now.end_of_day
      endtime = DateTime.parse(params[:endvalue]).end_of_day if params[:endvalue].to_s.size > 0
      section = (endtime - begintime).to_i
      (section + 1).times do |i|
        categories.push (begintime + i.day).month.to_s + '-' + (begintime + i.day).day.to_s
        beginday = begintime + i.day
        endday = (begintime + i.day).end_of_day
        userincomearr.push user.userincomes.where('created_at between ? and ? and status = ?', beginday, endday, 1).sum('amount')
        userstayincomearr.push user.userincomes.where('created_at between ? and ? and status = ?', beginday, endday, 0).sum('amount')
      end
    end


    incomecount = user.userincomes.where('created_at between ? and ? and status = ?',begintime, endtime, 1).size
    stayincomecount = user.userincomes.where('created_at between ? and ? and status = ?',begintime, endtime, 0).size
    incomesum = user.userincomes.where('created_at between ? and ? and status = ?',begintime, endtime, 1).sum('amount')
    incomesum = ActiveSupport::NumberHelper.number_to_currency(incomesum, unit:'￥')
    stayincomesum = user.userincomes.where('created_at between ? and ? and status = ?',begintime, endtime, 0).sum('amount')
    stayincomesum = ActiveSupport::NumberHelper.number_to_currency(stayincomesum, unit:'￥')

    param = {
        categories: categories,
        userincomes: userincomearr,
        userstayincomes: userstayincomearr,
        incomecount: incomecount,
        stayincomecount: stayincomecount,
        incomesum: incomesum,
        stayincomesum: stayincomesum
    }
    return_api(param)
  end

  def team
    user = User.find_by_token(params[:token])
    child = User.find_by(id:params[:childid])
    child = User.find_by_token(params[:token]) if !child
    userheadarr = user_headsort(user.id, child.id, [])
    userheadarr.reverse!
    usercount = team_user_count(child.id, 0)
    agentcount = team_agent_count(child.id, 0)
    teamsales = team_sales(child.id, 0)
    childrens = user.childrens
    directagentcount = childrens.where('isagent = ?',1).size
    directsales = 0
    childrens.each do |f|
      directsales += f.orders.where('paystatus = ?', 1).sum('amount')
    end
    name = '***' + child.openid[4..-4].to_s
    name = child.nickname if child.nickname.to_s.size > 0
    name = child.name if child.name.to_s.size > 0
    phone = ''
    phone = child.realname.phone.to_s if child.realname
    if child.isagent == 1
    quarter = create_quarter
    useragent = child.useragents.where('quarter_id = ?', quarter.id).first
    agent = useragent.agent.name
    end
    userinfo = {
        id: child.id,
        headurl: child.headurl.to_s,
        name: name,
        phone: phone,
        agent: agent
    }
    param = {
        userheadarr: userheadarr,
        usercount: usercount,
        agentcount: agentcount,
        teamsales: ActiveSupport::NumberHelper.number_to_currency(teamsales, unit:'￥'),
        directagentcount: directagentcount,
        directsales: ActiveSupport::NumberHelper.number_to_currency(directsales, unit:'￥'),
        userinfo: userinfo
    }
    return_api(param)
  end

  def teamdetail
    user = User.find_by_token(params[:token])
    child = User.find_by(id:params[:childid])
    userheadarr = user_headsort(user.id, child.id, [])
    userheadarr.reverse!
    directagentlist = []
    childrens = child.childrens
    childrens.each do |f|
      name = '***' + f.openid[4,-4].to_s
      name = f.nickname.to_s if f.nickname.to_s.size > 0
      name = f.name if f.name.to_s.size > 0
          child_param = {
          id: f.id,
          name: name,
          headurl: f.headurl.to_s,
          teamusercount: team_user_count(f.id, 0),
          teamsales: team_sales(f.id, 0)
      }

    end
    param = {
        userheadarr: userheadarr,
        directagentlist: directagentlist
    }
    return_api(param)
  end

  def mytask
    user = User.find_by_token(params[:token])
    begintime = Time.now.beginning_of_quarter
    endtime = Time.now.end_of_day
    categories = []
    hastask = []
    staytask = []
    section = ((endtime - begintime) / 60 / 60 / 24).to_i
    quarter = create_quarter
    useragent = user.useragents.where('quarter_id = ?', quarter.id).first
    taskamount = useragent.agent.task
    (section + 1).times do |i|
      beginday = begintime + i.day
      endday = (begintime + i.day).end_of_day
      categories.push (begintime + i.day).month.to_s + '-' + (begintime + i.day).day.to_s
      lasthastask = 0
      lasthastask = hastask.last if hastask.size > 0
      hastask.push user.usertasks.where('created_at between ? and ?', beginday, endday).sum('amount') + lasthastask
      staytaskamount = 0
      staytaskamount = taskamount - hastask.sum if taskamount - hastask.sum > 0
      staytask.push staytaskamount
    end
    masklow = (taskamount * 0.33).round(2)
    maskhigh = (taskamount * 0.66).round(2)
    staycomplete = taskamount
    staycomplete = staytask.last if staytask.size > 0
    daystay = staycomplete / ((Time.now.end_of_quarter - Time.now) / 60 / 60 / 24).to_i
    daystay = ActiveSupport::NumberHelper.number_to_currency(staycomplete, unit:'')
    staycomplete = ActiveSupport::NumberHelper.number_to_currency(staycomplete, unit:'￥')
    hascomplete = 0
    hascomplete = hastask.last if hastask.size > 0
    hascomplete = ActiveSupport::NumberHelper.number_to_currency(hascomplete, unit:'￥')

    # owerordercount = user.orders.where('paytime between ? and ?', begintime, endtime).size
    # owerordersum = user.orders.where('paytime between ? and ?', begintime, endtime).sum('amount')
    # owerordersum = ActiveSupport::NumberHelper.number_to_currency(owerordersum, unit:'￥')
    # teamordercount = task_team_count(user.id, 0)
    # teamordersum = task_team_salse(user.id, 0)
    # teamordersum = ActiveSupport::NumberHelper.number_to_currency(teamordersum, unit:'￥')

    owerordercount = 0
    owerordersum = 0
    teamordercount = 0
    teamordersum = 0
    usertasks = user.usertasks.where('created_at between ? and ?', begintime, endtime)
    usertasks.each do |f|
      order = f.order
      orderuser = order.user
      if orderuser.id == user.id
        owerordercount += 1
        owerordersum += f.amount
      else
        owerordercount += 1
        owerordersum += f.amount
      end
    end
    owerordersum = ActiveSupport::NumberHelper.number_to_currency(owerordersum, unit:'￥')
    teamordersum = ActiveSupport::NumberHelper.number_to_currency(teamordersum, unit:'￥')

    param = {
        categories: categories,
        hastask: hastask,
        staytask: staytask,
        masklow: masklow,
        maskhigh: maskhigh,
        taskamount: ActiveSupport::NumberHelper.number_to_currency(taskamount, unit:'￥'),
        agent: useragent.agent.name,
        staycomplete: staycomplete,
        daystay: daystay,
        hascomplete: hascomplete,
        ordercount: user.usertasks.where('created_at between ? and ?', begintime, endtime).size,
        owerordercount: owerordercount,
        owerordersum: owerordersum,
        teamordercount: teamordercount,
        teamordersum: teamordersum
    }
    return_api(param)
  end

  def taskdetail
    user = User.find_by_token(params[:token])
    usertasks = user.usertasks.where('created_at between ? and ?', Time.now.beginning_of_quarter, Time.now.end_of_day).order('id desc').page(params[:page]).per(10)
    final = 0
    final = 1 if usertasks.last_page? || usertasks.out_of_range?
    tasklistarr = []
    usertasks.each do |f|
      task_param = {
          id: f.id,
          face: get_face_sort(user.id,f.order.user.id,[]),
          amount: ActiveSupport::NumberHelper.number_to_currency(f.amount, unit:'￥'),
          created_at: f.created_at.strftime('%Y-%m-%d %H:%M:%S')
      }
      tasklistarr.push task_param
    end
    param = {
        taskdetail: tasklistarr,
        final: final
    }
    return_api(param)
  end

  def mysales
    user = User.find_by_token(params[:token])
    begintime = DateTime.parse(Time.now.beginning_of_year.to_s)
    begintime = DateTime.parse(params[:startvalue]).beginning_of_day if params[:startvalue]
    endtime = DateTime.parse(Time.now.end_of_day.to_s)
    endtime = DateTime.parse(params[:endvalue]).end_of_day if params[:endvalue]
    section = (endtime - begintime).to_i + 1
    categories = []
    owerarr = []
    teamarr = []
    section.times.each do |i|
      beginday = begintime + i.day
      endday = (begintime + i.day).end_of_day
      categories.push beginday.month.to_s + '-' + beginday.day.to_s
      owerarr.push user.orders.where('paystatus = ? and paytime between ? and ?', 1, beginday, endday).sum('amount')
      teamarr.push sale_team_sum(user.id, user.id, beginday, endday, 0)
    end
    param = {
        categories: categories,
        ower: owerarr,
        team: teamarr,
        owercount: sale_ower_count(user.id, begintime, endtime),
        owersum: ActiveSupport::NumberHelper.number_to_currency(owerarr.sum, unit:'￥'),
        teamcount: sale_team_count(user.id, user.id, begintime, endtime, 0),
        teamsum: ActiveSupport::NumberHelper.number_to_currency(teamarr.sum, unit:'￥')
    }
    return_api(param)
  end

  def profit
    user = User.find_by_token(params[:token])
    userincomes = user.userincomes.where('status = ?', 1).order('id desc').page(params[:page]).per(10)
    userincomearr = []
    userincomes.each do |f|
      userincome_params = {
          id:f.id,
          summary: f.summary,
          created_at: f.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          amount: ActiveSupport::NumberHelper.number_to_currency(f.amount, unit:'￥')
      }
      userincomearr.push userincome_params
    end

    final = 0
    final = 1 if userincomes.last_page? || userincomes.out_of_range?

    monthprofit = user.userincomes.where('status = ? and created_at between ? and ?', 1, Time.now.beginning_of_month, Time.now.end_of_day).sum('amount')
    monthprofit = ActiveSupport::NumberHelper.number_to_currency(monthprofit, unit:'￥')
    quarterprofit = user.userincomes.where('status = ? and created_at between ? and ?', 1, Time.now.beginning_of_quarter, Time.now.end_of_day).sum('amount')
    quarterprofit = ActiveSupport::NumberHelper.number_to_currency(quarterprofit, unit:'￥')
    yearprofit = user.userincomes.where('status = ? and created_at between ? and ?', 1, Time.now.beginning_of_year, Time.now.end_of_day).sum('amount')
    yearprofit = ActiveSupport::NumberHelper.number_to_currency(yearprofit, unit:'￥')

    param = {
        profit: userincomearr,
        monthprofit: monthprofit,
        quarterprofit: quarterprofit,
        yearprofit: yearprofit,
        final: final
    }
    return_api(param)
  end

  private
  def cal_ordercount(userid, begintime, endtime, count)
    user = User.find(userid)
    count += user.orders.where('paytime between ? and ? and paystatus = ?',begintime, endtime, 1).size
    childrens = user.childrens
    if childrens.size > 0
      childrens.each do |f|
        cal_ordercount(f.id, begintime, endtime, count)
      end
    end
    count
  end

  def user_headsort(userid,childid,sortarr)
    child = User.find(childid)
    name = '***' + child.openid[4..-4]
    name = child.nickname if child.nickname.to_s.size > 0
    name = child.name if child.name.to_s.size > 0
    param = {
        id: child.id,
        name: name,
        headurl: child.headurl.to_s
    }
    sortarr.push param
    parent = child.parent
    if parent && userid != childid
      user_headsort(userid, parent.id, sortarr)
    end
    sortarr
  end

  def team_user_count(userid,usercount)
    childrens = User.find(userid).childrens
    usercount += childrens.size
    childrens.each do |f|
      team_user_count(f.id, usercount)
    end
    usercount
  end

  def team_agent_count(userid, usercount)
    childrens = User.find(userid).childrens.where('isagent = ?', 1)
    usercount += childrens.size
    childrens.each do |f|
      team_agent_count(f.id, usercount)
    end
    usercount
  end

  def team_sales(userid, amount)
    user = User.find(userid)
    amount += user.orders.where('paystatus = ?', 1).sum('amount')
    childrens = user.childrens
    childrens.each do |f|
      team_sales(f.id, amount)
    end
    amount
  end

  def get_face_sort(userid, childid, arr)
    child = User.find(childid)
    arr.push child.headurl.to_s
    parent = child.parent
    user = User.find(userid)
    if parent && parent.id != user.id
      get_face_sort(userid, parent.id, arr)
    elsif userid == childid
      arr.push user.headurl.to_s
    end
    arr
  end

  def task_team_count(userid, count)
    user = User.find(userid)
    count += user.orders.where('paystatus = ?', 1).size
    childrens = user.childrens
    childrens.each do |f|
      task_team_count(f.id, count)
    end
    count
  end

  def task_team_salse(userid, amount)
    user = User.find(userid)
    amount += user.orders.where('paystatus = ?', 1).sum('amount')
    childrens = user.childrens
    childrens.each do |f|
      task_team_salse(f.id, amount)
    end
    amount
  end

  def sale_ower_count(userid, begintime, endtime)
    user = User.find(userid)
    count = user.orders.where('paytime between ? and ? and paystatus = ?', begintime, endtime, 1).size
    count
  end

  def sale_ower_sum(userid, begintime, endtime)
    user = User.find(userid)
    mysum = user.orders.where('paytime between ? and ? and paystatus = ?', begintime, endtime, 1).sum('amount')
    mysum
  end

  def sale_team_count(userid, childid, begintime, endtime, count)
    user = User.find(childid)
    if userid != childid
      count += user.orders.where('paystatus = ? and paytime between ? and ?', 1, begintime, endtime).size
    end
    childrens = user.childrens
    childrens.each do |f|
      count += sale_team_count(userid, f.id, begintime, endtime, count)
    end
    count
  end

  def sale_team_sum(userid, childid, begintime, endtime, count)
    user = User.find(childid)
    if userid != childid
      count += user.orders.where('paystatus = ? and paytime between ? and ?', 1, begintime, endtime).sum('amount')
    end
    childrens = user.childrens
    childrens.each do |f|
      count += sale_team_sum(userid, f.id, begintime, endtime, count)
    end
    count
  end

end
