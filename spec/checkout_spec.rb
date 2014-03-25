require 'spec_helper'

describe Checkout do
  it { should belong_to :inventory }
  it { should belong_to :cashier }
  it { should belong_to :customer}

end
