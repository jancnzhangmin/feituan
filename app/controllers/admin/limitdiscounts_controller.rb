class Admin::LimitdiscountsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      limitdiscounts = Limitdiscount.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      limitdiscounts = Limitdiscount.all.order('updated_at desc')
    end
    limitdiscounts = limitdiscounts.page(params[:page]).per(params[:per])
    limitdiscountarr = []
    limitdiscounts.each do |f|
      limitdiscount_param ={
          id: f.id,
          name: f.name,
          status: f.status,
          begintime: f.begintime.strftime('%Y-%m-%d %H:%M:%S'),
          endtime: f.endtime.strftime('%Y-%m-%d %H:%M:%S'),
          priority: f.priority,
          limitdiscountuser: f.limitdiscountusers.size,
          limitdiscountproduct: f.limitdiscountproducts.size,
      }
      limitdiscountarr.push limitdiscount_param
    end
    param = {
        data:limitdiscountarr,
        total:Limitdiscount.all.size
    }
    return_res(param)
  end

  def show
    limitdiscount = Limitdiscount.find(params[:id])
    statu = false
    statu = true if limitdiscount.status == 1
    priority = false
    priority = true if limitdiscount.priority == 1
    param = {
        id: limitdiscount.id,
        name: limitdiscount.name,
        status: statu,
        priority: priority,
        limittype: limitdiscount.limittype,
        limitdiscountuser: limitdiscount.limitdiscountusers.map{|n|n.user_id},
        activetime: [limitdiscount.begintime, limitdiscount.endtime],
        summary: limitdiscount.summary
    }
    return_res(param)
  end

  def create
    data = JSON.parse(params[:data])
    statu = 0
    statu = 1 if data["statu"]
    priority = 0
    priority =1 if data["priority"]
    limitdiscount = Limitdiscount.create(
        name:data["name"],
        begintime:data["activetime"][0],
        endtime:data["activetime"][1],
        status:statu,
        priority:priority,
        limittype:data["limittype"],
        summary:data["summary"]
    )
    if data["limitdiscount_status"]
      data["limitdiscountuser"].each do |f|
        limitdiscount.limitdiscountusers.create(user_id:f)
      end
    end
    return_res('')
  end

  def update
    limitdiscount = Limitdiscount.find(params[:id])
    data = JSON.parse(params[:data])
    statu = 0
    statu = 1 if data["statu"]
    priority = 0
    priority =1 if data["priority"]
    limitdiscount.update(
        name: data["name"],
        begintime: data["activetime"][0],
        endtime: data["activetime"][1],
        status: statu,
        priority: priority,
        limittype: data["limittype"],
        summary: data["summary"]
    )
    if data["limitdiscount_status"]
      limitdiscount.limitdiscountusers.destroy_all
      data["limitdiscountuser"].each do |f|
        limitdiscount.limitdiscountusers.create(user_id:f)
      end
    end
    return_res('')
  end

  def destroy
    limitdiscount = Limitdiscount.find(params[:id])
    limitdiscount.destroy
    return_res('')
  end

  def get_users
    users = User.all
    userarr = []
    users.each do |f|
      label = f.nickname.to_s
      label = f.name if f.name.to_s.size > 0
      label = f.aliasname if f.aliasname.to_s.size > 0
      param = {
          key:f.id,
          label:label
      }
      if label.size > 0
        userarr.push param
      end
    end
    return_res(userarr)
  end
end
