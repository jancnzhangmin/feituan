class Admin::BuyfullsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      buyfulls = Buyfull.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      buyfulls = Buyfull.all.order('updated_at desc')
    end
    buyfulls = buyfulls.page(params[:page]).per(params[:per])
    buyfullarr = []
    buyfulls.each do |f|
      buyfulls_param ={
          id: f.id,
          name: f.name,
          status: f.status,
          begintime: f.begintime.strftime('%Y-%m-%d %H:%M:%S'),
          endtime: f.endtime.strftime('%Y-%m-%d %H:%M:%S'),
          priority: f.priority,
          buyfulluser: f.buyfullusers.size,
          buyfullproduct: f.buyfullproducts.size,
          buyfullgiveproduct: f.buyfullgiveproducts.size
      }
      buyfullarr.push buyfulls_param
    end
    param = {
        data:buyfullarr,
        total:Buyfull.all.size
    }
    return_res(param)
  end

  def show
    buyfull = Buyfull.find(params[:id])
    statu = false
    statu = true if buyfull.status == 1
    priority = false
    priority = true if buyfull.priority == 1
    buyfull_param = {
        id: buyfull.id,
        name: buyfull.name,
        status: statu,
        priority: priority,
        limittype: buyfull.limittype,
        buyfulluser: buyfull.buyfullusers.map{|n|n.user_id},
        activetime: [buyfull.begintime, buyfull.endtime]
    }
    return_res(buyfull_param)
  end

  def create
    data = JSON.parse(params[:data])
    statu = 0
    statu = 1 if data["statu"]
    priority = 0
    priority =1 if data["priority"]
    buyfull = Buyfull.create(
        name:data["name"],
        begintime:data["activetime"][0],
        endtime:data["activetime"][1],
        status:statu,
        priority:priority,
        limittype:data["limittype"],
        summary:data["summary"]
    )
    if data["buyfulluser_status"]
      data["buyfulluser"].each do |f|
        buyfull.buyfullusers.create(user_id:f)
      end
    end
    return_res('')
  end

  def update
    buyfull = Buyfull.find(params[:id])
    data = JSON.parse(params[:data])
    statu = 0
    statu = 1 if data["statu"]
    priority = 0
    priority =1 if data["priority"]
    buyfull.update(
        name: data["name"],
        begintime: data["activetime"][0],
        endtime: data["activetime"][1],
        status: statu,
        priority: priority,
        limittype: data["limittype"],
        summary: data["summary"]
    )
    if data["buyfulluser_status"]
      buyfull.buyfullusers.destroy_all
      data["buyfulluser"].each do |f|
        buyfull.buyfullusers.create(user_id:f)
      end
    end
    return_res('')
  end

  def destroy
    buyfull = Buyfull.find(params[:id])
    buyfull.destroy
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
