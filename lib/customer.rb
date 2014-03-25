class Customer < ActiveRecord::Base
  has_many :checkouts
  has_many :cashiers, through: :checkouts
  has_many :inventories, through: :checkouts
end
