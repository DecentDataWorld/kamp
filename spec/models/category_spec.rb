require 'rails_helper'

describe Category do
  describe 'validations' do
    it { should validate_presence_of(:name).with_message("Name is required") }
  end
end
