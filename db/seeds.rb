# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


setting = Setting.first
if setting
  puts '设置已存在，忽略'
else
  Setting.create(wxappid:'00000000', wxappsecret:'000000', autooutdepot:'0', receivetime:'15', evaluatetime:'15')
  puts '设置初始化成功'
end

delivermode = Delivermode.find_by_keyword('cod')
if delivermode
  puts '货到付款已存在，忽略'
else
  Delivermode.create(weighting:50, isdefault:0, name:'货到付款', keyword:'cod')
  puts '货到付款初始化成功'
end

delivermode = Delivermode.find_by_keyword('sr')
if delivermode
  puts '自提已存在，忽略'
else
  Delivermode.create(weighting:0, isdefault:0, name:'自提', keyword:'sr')
  puts '自提初始化成功'
end

delivermode = Delivermode.find_by_keyword('pay')
if delivermode
  puts '线上支付已存在，忽略'
else
  Delivermode.create(weighting:0, isdefault:1, name:'线上支付', keyword:'pay')
  puts '线上支付初始化成功'
end



