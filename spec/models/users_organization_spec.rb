require 'rails_helper'

describe UsersOrganization do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:organization) }
  end

  describe 'validations' do
    it { should validate_presence_of(:organization).with_message("Organization is required") }
    it { should validate_presence_of(:user).with_message("Picking a member is required") }
  end
end
