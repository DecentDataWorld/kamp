require 'rails_helper'

describe Resource do
  describe 'associations' do
    it { should have_many(:resourcings) }
    it { should have_many(:collections) }
    it { should belong_to(:activity) }
    it { should belong_to(:collection) }
    it { should belong_to(:author) }
    it { should belong_to(:organization) }
    it { should belong_to(:license) }
    it { should belong_to(:batch) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name).with_message("Name is required") }
    it { should validate_presence_of(:description).with_message("A description of this resource is required") }
    it { should validate_presence_of(:resource_type).with_message("Choose a resource type") }
    it { should validate_presence_of(:tag_list).with_message("Choose at least one tag") }
  end
end
