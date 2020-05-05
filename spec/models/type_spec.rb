require 'rails_helper'

describe Type do
  describe 'associations' do
    it { should have_many(:collections) }
  end
end
