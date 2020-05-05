require 'rails_helper'

RSpec.describe OrganizationApplication, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:organization) }
  end
end
