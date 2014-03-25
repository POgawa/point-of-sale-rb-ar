require 'spec_helper'


describe Inventory do
  it {should belong_to :product}
  it {should have_many :checkouts}
end
