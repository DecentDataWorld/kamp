require 'rails_helper'

describe UserType do
  describe 'associations' do
    it { should have_many(:users) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_type).with_message("User Type is required") }
  end
end
