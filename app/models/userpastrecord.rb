class Userpastrecord < ApplicationRecord
  belongs_to :user
  belongs_to :examine
end
