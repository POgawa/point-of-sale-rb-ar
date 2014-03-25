class Checkout < ActiveRecord::Base
  belongs_to :cashier
  belongs_to :customer
  belongs_to :inventory
end
