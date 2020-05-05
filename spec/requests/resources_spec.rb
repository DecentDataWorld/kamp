require 'rails_helper'

describe "Resources" do
  describe "GET /resources" do
    it "redirects if not authorized" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get resources_path
      response.status.should be(302)
    end
  end
end
