require 'rails_helper'

describe "Batches" do
  describe "GET /batches" do
    it "redirects if not authorized" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get batches_path
      response.status.should be(302)
    end
  end
end
