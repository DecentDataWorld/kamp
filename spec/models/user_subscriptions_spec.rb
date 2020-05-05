require 'rails_helper'

RSpec.describe UserSubscriptions, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:organization) }
  end
end
