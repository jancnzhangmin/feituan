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



