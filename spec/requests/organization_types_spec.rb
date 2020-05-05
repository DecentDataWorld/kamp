require 'rails_helper'

describe "OrganizationTypes" do
  describe "GET /organization_types" do
    it "redirects if not authorized" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get organization_types_path
      response.status.should be(302)
    end
  end
end
