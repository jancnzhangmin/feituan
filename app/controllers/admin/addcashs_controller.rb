class Admin::AddcashsController < ApplicationController
  def index
    if params[:order] && params[:prop] && params[:prop].size > 0
      order = 'asc'
      order = 'desc' if params[:order] == 'descending'
      addcashs = Addcash.all.order(Arel.sql("convert(#{params[:prop]} USING GBK) #{order}"))
    else
      addcashs = Addcash.all.order('updated_at desc')
    end
    addcashs = addcashs.page(params[:page]).per(params[:per])
    addcasharr = []
    addcashs.each do |f|
      addcash_param ={
          id: f.id,
          name: f.name,
          status: f.status,
          begintime: f.begintime.strftime('%Y-%m-%d %H:%M:%S'),
          endtime: f.endtime.strftime('%Y-%m-%d %H:%M:%S'),
          priority: f.priority,
          addcashproduct: f.addcashproducts.size,
          addcashgive: f.addcashgis.size,
          addcashuser: f.addcashusers.size
      }
      addcasharr.push addcash_param
    end
    param = {
        data:addcasharr,
        total:Addcash.all.size
    }
    return_res(param)
  end

  def show
    addcash = Addcash.find(params[:id])
    statu = false
    statu = true if addcash.status == 1
    priority = false
    priority = true if addcash.priority == 1
    addcash_param = {
        id: addcash.id,
        name: addcash.name,
        status: statu,
        priority: priority,
        limittype: addcash.limittype,
        addcashuser: addcash.addcashusers.map{|n|n.user_id},
        activetime: [addcash.begintime, addcash.endtime],
        summary: addcash.summary
    }
    return_res(addcash_param)
  end

  def create
    data = JSON.parse(params[:data])
    statu = 0
    statu = 1 if data["statu"]
    priority = 0
    priority =1 if data["priority"]
    addcash = Addcash.create(
        name:data["name"],
        begintime:data["activetime"][0],
        endtime:data["activetime"][1],
        status:statu,
        priority:priority,
        limittype:data["limittype"],
        summary:data["summary"]
    )
    if data["addcashuser_status"]
      data["addcashuser"].each do |f|
        addcash.addcashusers.create(user_id:f)
      end
    end
    return_res('')
  end

  def update
    addcash = Addcash.find(params[:id])
    data = JSON.parse(params[:data])
    statu = 0
    statu = 1 if data["statu"]
    priority = 0
    priority =1 if data["priority"]
    addcash.update(
        name: data["name"],
        begintime: data["activetime"][0],
        endtime: data["activetime"][1],
        status: statu,
        priority: priority,
        limittype: data["limittype"],
        summary: data["summary"]
    )
    if data["addcashuser_status"]
      addcash.addcashusers.destroy_all
      data["addcashuser"].each do |f|
        addcash.addcashusers.create(user_id:f)
      end
    end
    return_res('')
  end

  def destroy
    addcash = Addcash.find(params[:id])
    addcash.destroy
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
