class Admingroup < ApplicationRecord
  has_and_belongs_to_many :admins
  has_many :admingroupauths
  has_many :auths, through: :admingroupauths
end
