class Product < ApplicationRecord
  has_many :buyfullproducts, dependent: :destroy
  has_many :buyfullgiveproducts, dependent: :destroy
  has_and_belongs_to_many :productclas
  has_many :productpvs, dependent: :destroy
  has_and_belongs_to_many :statements
  has_many :productbanners, dependent: :destroy
  has_many :buyparams, dependent: :destroy
  has_many :showparams, dependent: :destroy
  has_many :indepotdetails, dependent: :destroy
  has_many :outdepotdetails, dependent: :destroy
  has_many :depots, dependent: :destroy
  has_many :reportlostdetails, dependent: :destroy
  has_many :reportoverflowdetails, dependent: :destroy
  has_many :agentprices, dependent: :destroy
  has_many :addcashproducts, dependent: :destroy
  #has_many :addcashgives, dependent: :destroy
  has_many :addcashgis, dependent: :destroy
  has_many :orderdetails, dependent: :destroy
  has_many :evaluates, dependent: :destroy
  has_many :limitdiscountproducts, dependent: :destroy
  has_many :buycars, dependent: :destroy
  has_many :productshares, dependent: :destroy
  has_and_belongs_to_many :delivermodes
  has_and_belongs_to_many :todaydeals

  after_save :create_pinyin

  private
  def create_pinyin
    pinyin = PinYin.abbr(self.name)
    fullpinyin = PinYin.of_string(self.name).join
    if pinyin != self.pinyin || fullpinyin != self.fullpinyin
      self.pinyin = pinyin
      self.fullpinyin = fullpinyin
      self.save
    end
  end
end
