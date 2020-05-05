require 'rails_helper'

describe Batch do
  describe 'associations' do
    it { should have_many(:resources) }
    it { should belong_to(:uploader) }
  end
end
