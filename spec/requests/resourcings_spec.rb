require 'rails_helper'

describe "Resourcings" do
  describe "GET /resourcings" do
    it "redirects if not authorized" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get resourcings_path
      response.status.should be(302)
    end
  end
end
