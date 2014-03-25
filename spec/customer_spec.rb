require 'spec_helper'

describe Customer do
  it {should have_many :checkouts}
  it {should have_many :cashiers}
  it {should have_many :inventories}

end
