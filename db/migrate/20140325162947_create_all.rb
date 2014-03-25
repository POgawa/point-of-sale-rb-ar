class CreateAll < ActiveRecord::Migration
  def change
    create_table :customer do |t|
      t.column :name, :string

     t.timestamps
    end
    create_table :cashier do |t|
      t.column :name, :string
    end
    create_table :product do |t|
      t.column :name, :string
      t.column :price, :int

     t.timestamps
   end
    create_table :checkout do |t|
      t.column :customer_id, :int
      t.column :product_id, :int
      t.column :cashier_id, :int

     t.timestamps
    end
  end
end
