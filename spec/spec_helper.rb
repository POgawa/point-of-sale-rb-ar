require 'active_record'
require 'rspec'
require 'shoulda-matchers'

require './lib/checkout'
require './lib/product'
require './lib/customer'
require './lib/cashier'
require './lib/inventory'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['test']
ActiveRecord::Base.establish_connection(development_configuration)

RSpec.configure do |config|
  config.after(:each) do
    Checkout.all.each { |task| task.destroy }
    Customer.all.each { |task| task.destroy }
    Cashier.all.each { |task| task.destroy }
    Product.all.each { |task| task.destroy }
  end
end
