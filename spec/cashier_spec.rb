require 'spec_helper'


describe Cashier do
  it {should have_many :checkouts}
  it {should have_many :customers}
  it { should have_many :inventories}
end
