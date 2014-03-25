class Inventory < ActiveRecord::Base
  belongs_to :product
  has_many :checkouts
  has_many :customers, through: :checkouts
  has_many :cashiers, through: :checkouts
end
