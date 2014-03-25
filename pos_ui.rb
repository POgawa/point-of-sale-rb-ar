require 'active_record'
require './lib/josh'
require './lib/product'
require './lib/cashier'
require './lib/checkout'
require './lib/customer'
require './lib/inventory'
require 'date'
require 'pry'


ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))['development'])


def welcome
  puts "Welcome to the POS!"
  main_menu
end

def main_menu
  choice = nil
  until choice == 'X'
    puts "M - Login as a manager"
    puts "C - Login as a cashier"
    puts "X - Exit"
    choice = gets.chomp.upcase
    case choice
    when 'M'
      manager_menu
    when 'C'
      cashier_login
    when 'X'
      puts "Goodbye!"
    else
      puts "Invalid Input!"
    end
  end
end


def manager_menu


  choice = nil
  until choice == 'X'
    puts "C - Add a cashier"
    puts "P - Add a product"
    puts "S - View sales from date range"
    puts "L - View numbers of customers by cashier"
    puts "R - Restock Inventory"
    puts "X - Go back"
    choice = gets.chomp.upcase
    case choice
    when 'R'
      restock
    when 'C'
      add_cashier
    when 'P'
      add_product
    when 'S'
      sales_report
    when 'L'
      list_customers
    when 'X'
    else
      puts "Invalid Input!"
    end
  end
end

def cashier_login
  puts 'Enter your name'
  name = gets.chomp
  current_cashier = Cashier.where({name: name}).first
  if current_cashier != nil
    cashier_menu(current_cashier)
  else
    puts "Not a valid login!"
  end

end

def cashier_menu(current_cashier)
  choice = nil
  until choice == 'X'
    puts "N - New transaction"
    puts "X - Go Back"
    choice = gets.chomp.upcase
    case choice
    when 'N'
      transaction(current_cashier)
    when 'X'
    else
      puts 'Invalid Input'
    end
  end
end

def add_cashier
  puts "Enter a cashier name"
  name = gets.chomp
  Cashier.create({ name: name})
  puts "#{name} added to your cashiers!"
end

def add_product
  puts "Enter a product name"
  name = gets.chomp
  puts "Enter a price"
  price = gets.chomp
  puts "How many of this product are you adding to your inventory?"
  inventory = gets.chomp.to_i
  new_product = Product.create({ name: name, price: price})
  inventory.times {Inventory.create({product_id: new_product.id})}
  # Inventory.create({product_id: new_product.id})
  puts "#{name} has been added at $#{price}"
end

def restock
  list_products
  puts "Enter the number of the product you wish to restock"
  prod_restock = Product.where({ id: gets.chomp})
  puts "How many of this product do you wish to restock"
  num = gets.chomp.to_i
  num.times {Inventory.create({product_id: prod_restock.first.id})}
  puts "#{num} of #{prod_restock.first.name} have been added to your stock"
end

def transaction(current_cashier)
  current_customer = Customer.create
  checkouts = []
  list_in_stock
  new_product =  nil
  while new_product != 'x'
    puts "Select the number of the product you would like to add to this checkout or x to finish"
    new_product = gets.chomp
    selected_product = Inventory.where({product_id: new_product}).first
    if selected_product != nil
      binding.pry
      checkouts << Checkout.create({customer_id: current_customer.id, cashier_id: current_cashier.id, product_id: selected_product.id} )
      puts "#{selected_product.name} has been added to your cart!"

    elsif new_product == 'x'
      puts "Your total:\t\t$#{checkout_total(current_customer)}"
      remove_inventory(checkouts)
    else
      puts "Selected product not avalible"
    end

  end
end

def checkout_total(current_customer)
  checkouts = Checkout.where({customer_id: current_customer.id})
  total = 0
  puts "Your receipt"
  checkouts.each do |checkout|
    puts "#{checkout.product.name}:\t\t$#{checkout.product.price}"
    total += checkout.product.price
  end
  return total
end

def remove_inventory(checkouts)
  Inventory.where
end

def list_in_stock
  Inventory.select(:product_id).distinct.each { |inventory| puts "#{inventory.product.id}) #{inventory.product.name}"}
end

def list_products
  Product.all.each{|product| puts "#{product.id}) #{product.name}"}
end

def sales_report
  total = 0
  puts "Enter the beginning date range you would like to search: ie 20XX-01-01"
  begin_date = Date.parse(gets.chomp)
  puts "Enter the ending date range you would like to search: ie 20XX-01-01"
  end_date = Date.parse(gets.chomp)
  sales = Checkout.where(:created_at => begin_date.beginning_of_day..end_date.end_of_day)
  sales.each do |sales|
    puts "#{sales.product.name}:\t\t$#{sales.product.price}"
    total += sales.product.price
  end
  puts "Your total:\t\t$#{total}"
end

def list_customers
  list_cashiers
  puts "Please enter the number of the cashier you would like to look at:"
  cashier_name = gets.chomp

  total = 0
  puts "Enter the beginning date range you would like to search: ie 20XX-01-01"
  begin_date = Date.parse(gets.chomp)
  puts "Enter the ending date range you would like to search: ie 20XX-01-01"
  end_date = Date.parse(gets.chomp)
  customer_cashiers = Checkout.where({:created_at => begin_date.beginning_of_day..end_date.end_of_day, :cashier_id => cashier_name})
  puts "They helped #{customer_cashiers.select(:customer_id).distinct.length} customers in that date range."
end

def list_cashiers
  Cashier.all.each{|cashier| puts "#{cashier.id}) #{cashier.name}"}
end


welcome





