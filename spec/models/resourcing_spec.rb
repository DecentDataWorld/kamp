require 'rails_helper'

describe Resourcing do
  describe 'associations' do
    it { should belong_to(:resource) }
    it { should belong_to(:resourceable) }
    it { should accept_nested_attributes_for(:resource) }
  end
end
