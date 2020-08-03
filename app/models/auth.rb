class Auth < ApplicationRecord
  has_many :admingroupauths
  has_many :admingroups, through: :admingroupauths
end
