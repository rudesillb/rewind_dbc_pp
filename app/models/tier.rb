class Tier < ActiveRecord::Base
  has_one :user
  validates :number, uniqueness: true
end
