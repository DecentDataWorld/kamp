require 'rails_helper'

describe OrganizationType do
  describe 'associations' do
    it { should have_many(:organizations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:organization_type).with_message("Organization Type is required") }
  end
end
