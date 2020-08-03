class User < ApplicationRecord
  has_many :receiveadds, dependent: :destroy
  has_many :withdrawals, dependent: :destroy
  has_one :realname, dependent: :destroy
  has_many :usertasks, dependent: :destroy
  has_many :userincomes, dependent: :destroy
  has_many :usersales, dependent: :destroy
  has_many :userrealsales, dependent: :destroy
  has_many :userpastrecords, dependent: :destroy
  has_many :buycars, dependent: :destroy
  has_many :childrens, class_name: "User", foreign_key: "up_id"
  belongs_to :parent, class_name: "User", foreign_key: "up_id", optional: true
  has_many :orders
  has_many :addrs, dependent: :destroy
  has_many :charges, dependent: :destroy
  has_many :useragents

  after_create :create_uuid



  private
  def create_uuid
    if self.token.to_s.size == 0
      self .token = UUIDTools::UUID.timestamp_create.to_s.tr('-','')
      self.save
    end
  end
end
