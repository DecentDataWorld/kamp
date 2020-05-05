require 'rails_helper'

describe Collection do
  describe 'associations' do
    it { should have_many(:resources) }
    it { should have_many(:resourcings) }
    it { should belong_to(:author) }
    it { should belong_to(:activity) }
    it { should belong_to(:maintainer) }
    it { should belong_to(:organization) }
    it { should belong_to(:type) }
    it { should belong_to(:license) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title).with_message("Title is required") }
    it { should validate_presence_of(:description).with_message("A description is required") }
  end
end
