require 'rails_helper'

RSpec.describe Banner, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:banner_type) }
  end
end
