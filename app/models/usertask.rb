class Usertask < ApplicationRecord
  belongs_to :user
  belongs_to :agent, optional: true
  belongs_to :order
end
