class Admin::SettingsController < ApplicationController
  def index
    setting = Setting.first
    return_res(setting)
  end
  def update
    data = JSON.parse(params[:data])
    setting = Setting.find(params[:id])
    setting.wxappid = data["wxappid"] if data["wxappid"]
    setting.wxappsecret = data["wxappsecret"] if data["wxappsecret"]
    autooutdepot = 1 if data["autooutdepot"] == true || data["autooutdepot"] == 1
    autooutdepot = 0 if data["autooutdepot"]  == false || data["autooutdepot"] == 0
    setting.autooutdepot = autooutdepot
    setting.receivetime = data["receivetime"]
    setting.evaluatetime = data["evaluatetime"]
    setting.amapkey = data["amapkey"]
    setting.qrcode = params[:qrcode]
    setting.kuaidikey = data["kuaidikey"]
    setting.kuaidicustomer = data["kuaidicustomer"]
    setting.partnerid = data["partnerid"]
    setting.sendmanname = data["sendmanname"]
    setting.sendmanmobile = data["sendmanmobile"]
    setting.sendmanprintaddr = data["sendmanprintaddr"]
    setting.kuaidisecret = data["kuaidisecret"]

    if setting.save
      return_res('', 10000,'设置已更新')
    else
      return_res('', 10001, setting.errors)
    end
  end
  def create

  end
end
