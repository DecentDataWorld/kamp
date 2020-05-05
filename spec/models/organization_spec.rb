require 'rails_helper'

describe Organization do
  describe 'associations' do
    it { should have_many(:resources) }
    it { should have_many(:collections) }
    it { should have_many(:organization_applications) }
    it { should have_many(:users) }
    it { should have_many(:users_organizations) }
    it { should belong_to(:organization_type) }
    it { should accept_nested_attributes_for(:users) }
    it { should accept_nested_attributes_for(:users_organizations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name).with_message("Name is required") }
  end
end
