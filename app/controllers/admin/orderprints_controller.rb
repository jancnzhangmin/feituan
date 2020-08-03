class Admin::OrderprintsController < ApplicationController
  def upload
    require 'roo'
    xlsx = Roo::Spreadsheet.open(params[:file].tempfile)
    rowarr = (2..xlsx.sheet(0).last_row)
    selfid = ''
    if Orderprint.last
      selfid = Orderprint.last.id.to_s
    end
    ordernumber = Time.now.strftime('%Y%m%d') + selfid + Time.now.strftime('%H%M%S')
    oldgroup = ''
    sheet = xlsx.sheet(0)
    orderprint = nil
    rowarr.each do |f|
      if oldgroup != sheet.row(f)[1].to_s
        orderprint = Orderprint.create(
            username:sheet.row(f)[5],
            userphone:sheet.row(f)[6],
            ordernumber:ordernumber,
            address:sheet.row(f)[9],
            receiveuser:sheet.row(f)[7],
            receivephone: sheet.row(f)[8],
            summary: sheet.row(f)[10])
        oldgroup = sheet.row(f)[1].to_s
        selfid = (selfid.to_i + 1).to_s
        ordernumber = Time.now.strftime('%Y%m%d') + selfid + Time.now.strftime('%H%M%S')
      end
      orderproduct = Orderproduct.find_by_selfnumber(sheet.row(f)[0])
      orderprint.orderprintdetails.create(orderproduct_id: orderproduct.id, number:sheet.row(f)[4])
    end
    return_res('')
  end

end
