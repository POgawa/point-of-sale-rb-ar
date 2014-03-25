class Mybad < ActiveRecord::Migration
  def change
    rename_table :cashier, :cashiers
    rename_table :customer, :customers
    rename_table :checkout, :checkouts
    rename_table :product, :products
  end
end
