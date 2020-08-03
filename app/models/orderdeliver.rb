class Orderdeliver < ApplicationRecord
  belongs_to :order

  has_attached_file :eleimg, :url => "/:attachment/:id/:basename.:extension",  :path => ":rails_root/public/:attachment/:id/:basename.:extension"
  do_not_validate_attachment_file_type :eleimg

  before_create :randomize_file_name

  private
  def randomize_file_name
    #archives 就是你在 has_attached_file :archives 使用的名字
    extension = '.jpg'
    #你可以改成你想要的文件名，把下面这个方法的第二个参数随便改了就可以了。
    self.eleimg.instance_write(:file_name, "#{Time.now.strftime("%Y%m%d%H%M%S")}#{rand(1000)}#{extension}")
  end
end
