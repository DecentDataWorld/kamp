require 'rails_helper'

describe Role do
  describe 'associations' do
    it { should have_and_belong_to_many(:users) }
    it { should belong_to(:resource) }
  end
end
