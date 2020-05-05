require 'rails_helper'

describe Activity do
  describe 'associations' do
    it { should have_many(:resources) }
    it { should have_many(:collections) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name).with_message("Name is required") }
  end
end
